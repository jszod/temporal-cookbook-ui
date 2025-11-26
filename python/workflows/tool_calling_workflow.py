"""
Tool calling workflow for Temporal AI Cookbook patterns.
"""

from temporalio import workflow

@workflow.defn
class ToolCallingWorkflow:
    @workflow.run
    async def run(self) -> dict:
        return "Tool Calling Workflow -  yet implemented"

tool_calling_workflow = ToolCallingWorkflow