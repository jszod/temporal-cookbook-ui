import os
from typing import Any, Dict

import litellm
from temporalio import activity
from temporalio.exceptions import ApplicationError

from activities.models import LiteLLMRequest

@activity.defn(name="activities.litellm_completion.create")
async def create(request: LiteLLMRequest) -> Dict[str, Any]:
    """
    Create a completion using LiteLLM with multi-provider support.
    
    Temporal best practice: disable LiteLLM retries and let Temporal handle retries.
    This activity accepts model strings directly - provider mapping is handled in
    the Elixir/Phoenix UI layer.
    
    Supported model formats (LiteLLM automatically routes to correct provider):
    - OpenAI: "gpt-4", "gpt-3.5-turbo", "gpt-4-turbo-preview"
    - Anthropic: "claude-3-opus-20240229", "claude-3-sonnet-20240229", "claude-3-haiku-20240307"
    - Groq: "groq/llama-3-70b", "groq/mixtral-8x7b"
    - Ollama: "ollama/gemma3:latest", "ollama/llama2", "ollama/mistral", "ollama/codellama"
    
    API keys are read from environment variables:
    - OPENAI_API_KEY for OpenAI models
    - ANTHROPIC_API_KEY for Anthropic models
    - GROQ_API_KEY for Groq models
    - OLLAMA_API_BASE for Ollama (e.g., http://127.0.0.1:11434 or http://localhost:11434)
      If not set, defaults to http://localhost:11434
    
    Args:
        request: LiteLLMRequest with model string, messages, and optional parameters
        
    Returns:
        Dict containing the raw LiteLLM response (includes choices, usage, etc.)
        
    Raises:
        ApplicationError: For non-retryable errors (authentication, bad request, etc.)
        APIError: For retryable errors (rate limits, timeouts, etc.) - re-raised for Temporal
    """
    kwargs = request.to_accompletion_kwargs()
    kwargs["num_retries"] = 0
    
    # Explicitly set Ollama API base if provided in environment
    # LiteLLM will use this for ollama/* models
    ollama_api_base = os.getenv("OLLAMA_API_BASE")
    if ollama_api_base and request.model.startswith("ollama/"):
        kwargs["api_base"] = ollama_api_base
    
    try:
        response = await litellm.acompletion(**kwargs)
    except (
        litellm.AuthenticationError,
        litellm.BadRequestError,
        litellm.InvalidRequestError,
        litellm.UnsupportedParamsError,
        litellm.JSONSchemaValidationError,
        litellm.ContentPolicyViolationError,
        litellm.NotFoundError,
    ) as e:
        raise ApplicationError(
            str(e),
            type=e.__class__.__name__,
            non_retryable=True,
        ) from e
    except litellm.APIError:
        raise
    
    return response