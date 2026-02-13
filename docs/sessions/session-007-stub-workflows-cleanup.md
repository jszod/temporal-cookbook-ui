# Session 007 - Stub Workflows Cleanup

**Date**: 2026-02-13
**Branch**: `feature/stub-workflows-cleanup`
**Focus**: Wire stub workflows to the UI, fix workflow ID prefixing, add Coming Soon indicators

---

## Accomplishments

### 1. Tool-Calling Pattern Enabled
- Changed `tool-calling` pattern status `:coming_soon` → `:available` in `pattern.ex`
- `WorkflowControls` now renders on `/patterns/tool-calling`

### 2. Workflow ID Prefixing Fixed
- `build_request/2` in `workflow.ex` now passes `pattern_id` to `generate_id/1`
- Workflow IDs now read as `"tool-calling-123456-4321"` instead of always `"litellm-123456-4321"`

### 3. Coming Soon UI Added
- **Catalog page** (`pattern_catalog_live.ex`): amber "Coming Soon" pill badge in top-right corner of cards with `:coming_soon` status
- **Detail page** (`pattern_detail_live.ex`): amber banner with 🚧 icon below the complexity badge for coming-soon patterns

### 4. Tests Updated
- `pattern_test.exs`: updated available-pattern count (1→2), updated tool-calling status assertion
- `pattern_detail_live_test.exs`: tool-calling test now checks for WorkflowControls; removed tool-calling from coming-soon list
- `workflow_test.exs`: updated workflow ID prefix assertion (`"litellm-"` → `"1-"`)
- All 133 tests + 23 doctests passing

---

## Key Lesson: Python Worker Restart Required on File Changes

**Problem**: After the stub workflows had `@workflow.defn(name="tool_calling_workflow")` added, running the workflow failed with:

```
NotFoundError: Workflow class tool_calling_workflow is not registered on this worker,
available workflows: DeepResearchWorkflow, DurableAgentWorkflow, ..., ToolCallingWorkflow, litellm_workflow
```

**Root cause**: The worker loaded workflow class definitions into memory at startup. The `name=` parameter in `@workflow.defn` was on disk but the running process had the old class definitions (without the name override), so Temporal registered them by class name instead of the explicit name string.

**Fix**: Restart the Python worker. Any change to a `.py` file requires a worker restart — there is no hot reload.

---

## Files Changed

| File | Change |
|------|--------|
| `lib/temporal_cookbook_ui/patterns/pattern.ex` | `tool-calling` status `:coming_soon` → `:available` |
| `lib/temporal_cookbook_ui/temporal/workflow.ex` | `generate_id()` → `generate_id(pattern_id)` |
| `lib/temporal_cookbook_ui_web/live/pattern_catalog_live.ex` | Coming Soon badge on cards |
| `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex` | Coming Soon banner on detail page |
| `test/temporal_cookbook_ui/patterns/pattern_test.exs` | Updated status assertions |
| `test/temporal_cookbook_ui_web/live/pattern_detail_live_test.exs` | Updated coming-soon test list |
| `test/temporal_cookbook_ui/temporal/workflow_test.exs` | Updated workflow ID prefix assertion |

---

## Next Steps
- Enable remaining stub patterns (structured-outputs, retry-policy, durable-agent, deep-research) when ready to implement
- Implement real logic for tool-calling workflow (Feature 003)
