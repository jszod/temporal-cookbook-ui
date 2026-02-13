"""
Durable agent workflow for Temporal AI Cookbook patterns.
"""

from dataclasses import dataclass
from typing import Any, Dict

from temporalio import workflow


@dataclass
class DurableAgentWorkflowOutput:
    """Output from durable agent workflow"""

    text: str


@workflow.defn(name="durable_agent_workflow")
class DurableAgentWorkflow:
    @workflow.run
    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        output = DurableAgentWorkflowOutput(
            text="Stub workflow - Durable agent workflow not fully implemented yet"
        )
        return {"text": output.text}


durable_agent_workflow = DurableAgentWorkflow
