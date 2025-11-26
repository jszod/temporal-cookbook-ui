import pytest
from unittest.mock import AsyncMock, patch
from typing import Any, Dict

import litellm
from temporalio.exceptions import ApplicationError

from activities.litellm_completion import create
from activities.models import LiteLLMRequest


class TestLitellmCompletion:
    """Unit tests for litellm_completion activity."""

    @pytest.mark.asyncio
    async def test_successful_completion(self):
        """Test successful completion returns response."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        expected_response = {
            "id": "chatcmpl-123",
            "choices": [{"message": {"content": "Hi there!"}}]
        }
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.return_value = expected_response
            
            result = await create(request)
            
            assert result == expected_response
            # Verify num_retries=0 is set
            mock_acompletion.assert_called_once()
            # Get kwargs - handle both call_args[1] and call_args.kwargs
            if hasattr(mock_acompletion.call_args, 'kwargs'):
                call_kwargs = mock_acompletion.call_args.kwargs
            else:
                call_kwargs = mock_acompletion.call_args[1] if len(mock_acompletion.call_args) > 1 else {}
            assert call_kwargs["num_retries"] == 0
            assert call_kwargs["model"] == "gpt-4"
            assert call_kwargs["messages"] == [{"role": "user", "content": "Hello"}]

    @pytest.mark.asyncio
    async def test_successful_completion_with_optional_params(self):
        """Test successful completion with optional parameters."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            temperature=0.7,
            max_tokens=100,
            timeout=30.0
        )
        
        expected_response = {"id": "chatcmpl-456", "choices": []}
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.return_value = expected_response
            
            result = await create(request)
            
            assert result == expected_response
            call_kwargs = mock_acompletion.call_args.kwargs
            assert call_kwargs["num_retries"] == 0
            assert call_kwargs["temperature"] == 0.7
            assert call_kwargs["max_tokens"] == 100
            assert call_kwargs["timeout"] == 30.0

    @pytest.mark.asyncio
    async def test_authentication_error_non_retryable(self):
        """Test AuthenticationError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        auth_error = litellm.AuthenticationError(
            message="Invalid API key",
            llm_provider="openai",
            model="gpt-4"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = auth_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "AuthenticationError"
            assert "Invalid API key" in str(exc_info.value)
            assert exc_info.value.__cause__ is auth_error

    @pytest.mark.asyncio
    async def test_bad_request_error_non_retryable(self):
        """Test BadRequestError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        bad_request_error = litellm.BadRequestError(
            message="Invalid request",
            model="gpt-4",
            llm_provider="openai"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = bad_request_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "BadRequestError"

    @pytest.mark.asyncio
    async def test_invalid_request_error_non_retryable(self):
        """Test InvalidRequestError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        invalid_error = litellm.InvalidRequestError(
            message="Invalid parameter",
            model="gpt-4",
            llm_provider="openai"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = invalid_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "InvalidRequestError"

    @pytest.mark.asyncio
    async def test_unsupported_params_error_non_retryable(self):
        """Test UnsupportedParamsError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        unsupported_error = litellm.UnsupportedParamsError(
            message="Unsupported parameter",
            model="gpt-4",
            llm_provider="openai"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = unsupported_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "UnsupportedParamsError"

    @pytest.mark.asyncio
    async def test_json_schema_validation_error_non_retryable(self):
        """Test JSONSchemaValidationError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        schema_error = litellm.JSONSchemaValidationError(
            model="gpt-4",
            llm_provider="openai",
            raw_response="{}",
            schema="{}"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = schema_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "JSONSchemaValidationError"

    @pytest.mark.asyncio
    async def test_content_policy_violation_error_non_retryable(self):
        """Test ContentPolicyViolationError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        policy_error = litellm.ContentPolicyViolationError(
            message="Content policy violated",
            model="gpt-4",
            llm_provider="openai"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = policy_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "ContentPolicyViolationError"

    @pytest.mark.asyncio
    async def test_not_found_error_non_retryable(self):
        """Test NotFoundError is wrapped as non-retryable ApplicationError."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        not_found_error = litellm.NotFoundError(
            message="Model not found",
            model="gpt-4",
            llm_provider="openai"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = not_found_error
            
            with pytest.raises(ApplicationError) as exc_info:
                await create(request)
            
            assert exc_info.value.non_retryable is True
            assert exc_info.value.type == "NotFoundError"

    @pytest.mark.asyncio
    async def test_api_error_retryable(self):
        """Test APIError is re-raised for Temporal retry handling."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        api_error = litellm.APIError(
            status_code=503,
            message="Service unavailable",
            llm_provider="openai",
            model="gpt-4"
        )
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.side_effect = api_error
            
            with pytest.raises(litellm.APIError) as exc_info:
                await create(request)
            
            assert exc_info.value is api_error
            # Verify it's not wrapped in ApplicationError
            assert isinstance(exc_info.value, litellm.APIError)

    @pytest.mark.asyncio
    async def test_num_retries_always_zero(self):
        """Test that num_retries is always set to 0 regardless of request."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            extra_options={"num_retries": 5}  # Should be overridden
        )
        
        expected_response = {"id": "chatcmpl-789", "choices": []}
        
        with patch("activities.litellm_completion.litellm.acompletion", new_callable=AsyncMock) as mock_acompletion:
            mock_acompletion.return_value = expected_response
            
            await create(request)
            
            call_kwargs = mock_acompletion.call_args.kwargs
            assert call_kwargs["num_retries"] == 0
