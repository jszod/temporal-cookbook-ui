"""
Workflow registry for Temporal AI Cookbook patterns.

This module imports all workflows to ensure they are registered with the Temporal when the package is imported.
"""

from .litellm_workflow import litellm_workflow
from .tool_calling_workflow import tool_calling_workflow
from .structured_outputs_workflow import structured_outputs_workflow
from .retry_policy_workflow import retry_policy_workflow
from .durable_agent_workflow import durable_agent_workflow
from .deep_research_workflow import deep_research_workflow

__all__ = [
    'deep_research_workflow',
    'durable_agent_workflow',
    'litellm_workflow',
    'retry_policy_workflow',
    'structured_outputs_workflow',
    'tool_calling_workflow',
]