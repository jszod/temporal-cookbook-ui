"""
Retry policy workflow for Temporal AI Cookbook patterns.
"""

from dataclasses import dataclass
from typing import Any, Dict

from temporalio import workflow


@dataclass
class RetryPolicyWorkflowOutput:
    """Output from retry policy workflow"""

    text: str


@workflow.defn(name="retry_policy_workflow")
class RetryPolicyWorkflow:
    @workflow.run
    async def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        output = RetryPolicyWorkflowOutput(
            text="Stub workflow - Retry policy workflow not fully implemented yet"
        )
        return {"text": output.text}


retry_policy_workflow = RetryPolicyWorkflow
