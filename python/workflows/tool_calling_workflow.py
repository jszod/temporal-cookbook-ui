"""
Tool calling workflow for Temporal AI Cookbook patterns.
"""

from dataclasses import dataclass
from typing import Any, Dict

from temporalio import workflow


@dataclass
class ToolCallingWorkflowOutput:
    """Output from tool calling workflow"""

    text: str  # generic stub message for now


@workflow.defn(name="tool_calling_workflow")
class ToolCallingWorkflow:
    @workflow.run
    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Execute Tool Calling workflow

        Args:

        Returns:
            Dictionary with parsed response data
        """
        output = ToolCallingWorkflowOutput(
            text="Stub workflow - tool calling workflow not fully implemented yet"
        )
        return {"text": output.text}


tool_calling_workflow = ToolCallingWorkflow
