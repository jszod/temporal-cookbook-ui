"""
Structured outputs workflow for Temporal AI Cookbook patterns.
"""

from dataclasses import dataclass
from typing import Any, Dict

from temporalio import workflow


@dataclass
class StructuredOutputsWorkflowOutput:
    """Output from structured outputs workflow"""

    text: str


@workflow.defn(name="structured_outputs_workflow")
class StructuredOutputsWorkflow:
    @workflow.run
    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        output = StructuredOutputsWorkflowOutput(
            text="Stub workflow - Structured outputs workflow not fully implemented yet"
        )
        return {"text": output.text}


structured_outputs_workflow = StructuredOutputsWorkflow
