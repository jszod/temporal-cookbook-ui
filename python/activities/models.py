from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Type, Union

@dataclass
class LiteLLMRequest:
    model: str
    messages: List[Dict[str, Any]]

    # Optional knobs: limited to the most common tweaks.
    temperature: Optional[float] = None     # Controls response creativity/randomness.
    max_tokens: Optional[int] = None        # Limits response length.
    timeout: Optional[Union[float, int]] = None    # Let's callers bound slow provider responses.
    response_format: Optional[Union[dict, Type[Any]]] = None # Response format for structured outputs.

    # Escape hatch for advanced parameters we don't model explicitly.
    extra_options: Dict[str, Any] = field(default_factory=dict)

    def to_accompletion_kwargs(self) -> Dict[str, Any]:
        """
        Convert to kwargs for litellm.completion.
        """
        kwargs = {
            "model": self.model,
            "messages": self.messages,
        }

        optional_values = {
            "temperature": self.temperature,
            "max_tokens": self.max_tokens,
            "timeout": self.timeout,
            "response_format": self.response_format,
        }
        
        for key, value in optional_values.items():
            if value is not None:
                kwargs[key] = value

        if self.extra_options:
            kwargs.update(self.extra_options)

        return kwargs