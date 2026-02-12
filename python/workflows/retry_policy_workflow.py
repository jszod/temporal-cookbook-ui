"""
Retry policy workflow for Temporal AI Cookbook patterns.
"""

from temporalio import workflow

@workflow.defn
class RetryPolicyWorkflow:
    @workflow.run
    async def run(self) -> dict:
        return "Retry Policy Workflow -  yet implemented"   

retry_policy_workflow = RetryPolicyWorkflow