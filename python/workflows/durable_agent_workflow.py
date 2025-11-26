"""
Durable agent workflow for Temporal AI Cookbook patterns.
"""

from temporalio import workflow

@workflow.defn
class DurableAgentWorkflow:
    @workflow.run
    async def run(self) -> dict:
        return "Durable Agent Workflow - not yet implemented"

durable_agent_workflow = DurableAgentWorkflow