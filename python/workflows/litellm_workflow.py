"""
LiteLLM workflow for Temporal AI Cookbook patterns.

This workflow orchestrates LLM completion requests using LiteLLM with multi-provider support.
It accepts model strings, prompts, and parameters, calls the LiteLLM activity, and returns
parsed response data including text, token usage, and latency metrics.
"""

from dataclasses import dataclass
from datetime import timedelta
from typing import Any, Dict, Optional

from temporalio import workflow
from temporalio.common import RetryPolicy

# Import models only (no activity import to avoid importing litellm in workflow)
from activities.models import LiteLLMRequest


@dataclass
class LiteLLMWorkflowInput:
    """Input parameters for LiteLLM workflow."""
    model: str  # Model string (e.g., "gpt-3.5-turbo", "claude-3-sonnet-20240229")
    prompt: str  # User prompt text
    temperature: Optional[float] = None  # Temperature (0.0-2.0)
    max_tokens: Optional[int] = None  # Maximum tokens in response


@dataclass
class LiteLLMWorkflowOutput:
    """Output from LiteLLM workflow."""
    text: str  # LLM response text
    model: str  # Model used
    prompt_tokens: Optional[int] = None  # Tokens in prompt
    completion_tokens: Optional[int] = None  # Tokens in completion
    total_tokens: Optional[int] = None  # Total tokens
    latency_ms: Optional[float] = None  # Latency in milliseconds
    cost_estimate: Optional[float] = None  # Estimated cost (if available)
    raw_response: Optional[Dict[str, Any]] = None  # Full raw response for debugging


@workflow.defn(name="litellm_workflow")
class LitellmWorkflow:
    """
    Workflow for executing LiteLLM completion requests.
    
    This workflow:
    1. Accepts model string, prompt, and optional parameters
    2. Calls the LiteLLM activity to get completion
    3. Parses response to extract text, tokens, and metrics
    4. Returns structured output for UI display
    """
    
    @workflow.run
    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute LiteLLM workflow.
        
        Args:
            input_data: Dictionary with keys:
                - model: Model string (required)
                - prompt: User prompt (required)
                - temperature: Optional temperature (0.0-2.0)
                - max_tokens: Optional max tokens
        
        Returns:
            Dictionary with parsed response data:
                - text: Response text
                - model: Model used
                - prompt_tokens: Tokens in prompt
                - completion_tokens: Tokens in completion
                - total_tokens: Total tokens
                - latency_ms: Latency in milliseconds
                - cost_estimate: Estimated cost
        """
        # Parse input
        workflow_input = LiteLLMWorkflowInput(
            model=input_data["model"],
            prompt=input_data["prompt"],
            temperature=input_data.get("temperature"),
            max_tokens=input_data.get("max_tokens"),
        )
        
        # Create activity request
        activity_request = LiteLLMRequest(
            model=workflow_input.model,
            messages=[{"role": "user", "content": workflow_input.prompt}],
            temperature=workflow_input.temperature,
            max_tokens=workflow_input.max_tokens,
        )
        
        # Call activity (Temporal handles retries automatically)
        # Note: Latency will be calculated from activity execution metadata
        # Workflows are deterministic, so we can't use real-time functions here
        # Use activity name string to avoid importing litellm in workflow code
        raw_response = await workflow.execute_activity(
            "activities.litellm_completion.create",
            activity_request,
            start_to_close_timeout=timedelta(seconds=60),
            retry_policy=RetryPolicy(
                initial_interval=timedelta(seconds=1),
                backoff_coefficient=2.0,
                maximum_interval=timedelta(seconds=60),
                maximum_attempts=5,
            ),
        )
        
        # Parse response (latency will be calculated from Temporal activity execution time)
        # For now, set latency to None - it can be calculated from workflow history
        output = self._parse_response(raw_response, workflow_input.model, None)
        
        # Return as dictionary for JSON serialization
        return {
            "text": output.text,
            "model": output.model,
            "prompt_tokens": output.prompt_tokens,
            "completion_tokens": output.completion_tokens,
            "total_tokens": output.total_tokens,
            "latency_ms": output.latency_ms,
            "cost_estimate": output.cost_estimate,
            "raw_response": output.raw_response,
        }
    
    def _parse_response(
        self, 
        raw_response: Dict[str, Any], 
        model: str, 
        latency_ms: Optional[float]
    ) -> LiteLLMWorkflowOutput:
        """
        Parse LiteLLM response to extract text, tokens, and metrics.
        
        LiteLLM response structure:
        {
            "id": "chatcmpl-...",
            "choices": [{"message": {"content": "..."}}],
            "usage": {
                "prompt_tokens": int,
                "completion_tokens": int,
                "total_tokens": int
            },
            "response_metadata": {...}  # May include latency, cost info
        }
        """
        # Extract text from first choice
        text = ""
        if raw_response.get("choices") and len(raw_response["choices"]) > 0:
            first_choice = raw_response["choices"][0]
            if "message" in first_choice and "content" in first_choice["message"]:
                text = first_choice["message"]["content"]
        
        # Extract token usage
        usage = raw_response.get("usage", {})
        prompt_tokens = usage.get("prompt_tokens")
        completion_tokens = usage.get("completion_tokens")
        total_tokens = usage.get("total_tokens")
        
        # Extract cost estimate if available (some providers include this)
        cost_estimate = None
        if "response_metadata" in raw_response:
            metadata = raw_response["response_metadata"]
            cost_estimate = metadata.get("cost") or metadata.get("estimated_cost")
        
        return LiteLLMWorkflowOutput(
            text=text,
            model=model,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=total_tokens,
            latency_ms=latency_ms,
            cost_estimate=cost_estimate,
            raw_response=raw_response,
        )


litellm_workflow = LitellmWorkflow