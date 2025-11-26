import pytest
from typing import Any, Dict
from activities.models import LiteLLMRequest


class TestLiteLLMRequest:
    """Unit tests for LiteLLMRequest dataclass."""

    def test_basic_instantiation(self):
        """Test basic instantiation with required fields only."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        assert request.model == "gpt-4"
        assert request.messages == [{"role": "user", "content": "Hello"}]
        assert request.temperature is None
        assert request.max_tokens is None
        assert request.timeout is None
        assert request.response_format is None
        assert request.extra_options == {}

    def test_instantiation_with_all_optional_fields(self):
        """Test instantiation with all optional fields set."""
        request = LiteLLMRequest(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": "Test"}],
            temperature=0.7,
            max_tokens=100,
            timeout=30.0,
            response_format={"type": "json_object"},
            extra_options={"top_p": 0.9}
        )
        
        assert request.model == "gpt-3.5-turbo"
        assert request.temperature == 0.7
        assert request.max_tokens == 100
        assert request.timeout == 30.0
        assert request.response_format == {"type": "json_object"}
        assert request.extra_options == {"top_p": 0.9}

    def test_to_accompletion_kwargs_minimal(self):
        """Test to_accomplish_kwargs with only required fields."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}]
        )
        
        kwargs = request.to_accompletion_kwargs()
        
        assert kwargs == {
            "model": "gpt-4",
            "messages": [{"role": "user", "content": "Hello"}]
        }

    def test_to_accompletion_kwargs_with_optional_fields(self):
        """Test to_accomplish_kwargs with optional fields set."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            temperature=0.8,
            max_tokens=200,
            timeout=60,
            response_format={"type": "json_object"}
        )
        
        kwargs = request.to_accompletion_kwargs()
        
        assert kwargs["model"] == "gpt-4"
        assert kwargs["messages"] == [{"role": "user", "content": "Hello"}]
        assert kwargs["temperature"] == 0.8
        assert kwargs["max_tokens"] == 200
        assert kwargs["timeout"] == 60
        assert kwargs["response_format"] == {"type": "json_object"}

    def test_to_accompletion_kwargs_excludes_none_values(self):
        """Test that None values are excluded from kwargs."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            temperature=0.5,
            # max_tokens, timeout, response_format are None
        )
        
        kwargs = request.to_accompletion_kwargs()
        
        assert "model" in kwargs
        assert "messages" in kwargs
        assert "temperature" in kwargs
        assert kwargs["temperature"] == 0.5
        assert "max_tokens" not in kwargs
        assert "timeout" not in kwargs
        assert "response_format" not in kwargs

    def test_to_accompletion_kwargs_with_extra_options(self):
        """Test that extra_options are merged into kwargs."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            temperature=0.7,
            extra_options={
                "top_p": 0.9,
                "frequency_penalty": 0.5,
                "presence_penalty": 0.3
            }
        )
        
        kwargs = request.to_accompletion_kwargs()
        
        assert kwargs["model"] == "gpt-4"
        assert kwargs["temperature"] == 0.7
        assert kwargs["top_p"] == 0.9
        assert kwargs["frequency_penalty"] == 0.5
        assert kwargs["presence_penalty"] == 0.3

    def test_to_accompletion_kwargs_extra_options_override(self):
        """Test that extra_options can override explicit fields."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            temperature=0.7,
            extra_options={"temperature": 0.9}  # Should override
        )
        
        kwargs = request.to_accompletion_kwargs()
        
        # extra_options are merged last, so they override
        assert kwargs["temperature"] == 0.9

    def test_to_accompletion_kwargs_timeout_with_float(self):
        """Test timeout can be a float."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            timeout=30.5
        )
        
        kwargs = request.to_accompletion_kwargs()
        assert kwargs["timeout"] == 30.5

    def test_timeout_with_int(self):
        """Test timeout can be an int."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            timeout=30
        )
        
        kwargs = request.to_accompletion_kwargs()
        assert kwargs["timeout"] == 30

    def test_response_format_with_dict(self):
        """Test response_format with a dictionary."""
        response_format = {"type": "json_object"}
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            response_format=response_format
        )
        
        kwargs = request.to_accompletion_kwargs()
        assert kwargs["response_format"] == response_format

    def test_response_format_with_type(self):
        """Test response_format with a Type."""
        from typing import TypedDict
        
        class ResponseSchema(TypedDict):
            name: str
            age: int
        
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            response_format=ResponseSchema
        )
        
        kwargs = request.to_accompletion_kwargs()
        assert kwargs["response_format"] == ResponseSchema

    def test_empty_extra_options(self):
        """Test that empty extra_options dict doesn't affect kwargs."""
        request = LiteLLMRequest(
            model="gpt-4",
            messages=[{"role": "user", "content": "Hello"}],
            extra_options={}
        )
        
        kwargs = request.to_accompletion_kwargs()
        # Should not include extra_options key, just the base fields
        assert "model" in kwargs
        assert "messages" in kwargs
        assert len(kwargs) == 2

    def test_complex_messages(self):
        """Test with complex message structures."""
        messages = [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "What is 2+2?"},
            {"role": "assistant", "content": "4"},
            {"role": "user", "content": "Explain why."}
        ]
        
        request = LiteLLMRequest(
            model="gpt-4",
            messages=messages
        )
        
        kwargs = request.to_accompletion_kwargs()
        assert kwargs["messages"] == messages

