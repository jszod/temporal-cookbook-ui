# Architecture Refactoring - Task Breakdown

**Created**: 2025-11-26
**Branch**: `feature/2-litellm-pattern`
**Estimated Total Time**: 14-19 hours

## Task Hierarchy

### PHASE 1: Domain Separation (2-3 hours)

#### Task 1.1: Create LLM Domain Module
**Estimated Time**: 30 minutes
**Dependencies**: None
**Description**: Create new `LLM.Provider` module to replace `Temporal.ProviderConfig`

**Subtasks**:
- [x] Create directory `lib/temporal_cookbook_ui/llm/`
- [x] Create file `lib/temporal_cookbook_ui/llm/provider.ex`
- [x] Copy and refactor code from `temporal/provider_config.ex`
- [x] Update module name and documentation
- [x] Verify module compiles: `mix compile`

**Files Created**:
- `lib/temporal_cookbook_ui/llm/provider.ex`

**Acceptance Criteria**:
- [x] Module defines `model_for_provider/1`
- [x] Module defines `available_providers/0`
- [x] Module defines `valid_provider?/1`
- [x] Module documentation is clear and accurate
- [x] Code compiles without warnings

---

#### Task 1.2: Update LiveView Imports
**Estimated Time**: 15 minutes
**Dependencies**: Task 1.1
**Description**: Update all files that import `ProviderConfig` to use new `LLM.Provider`

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`
  - Change: `alias TemporalCookbookUi.Temporal.ProviderConfig` → `alias TemporalCookbookUi.LLM.Provider`
  - Update function calls: `ProviderConfig.model_for_provider` → `Provider.model_for_provider`
- [ ] Update `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`
  - Change alias
  - Update function calls
- [ ] Search for any other references: `rg "ProviderConfig" lib/`
- [ ] Verify app compiles: `mix compile`

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`
- `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`

**Acceptance Criteria**:
- [x] All imports updated to use `LLM.Provider`
- [x] All function calls updated
- [x] No references to `ProviderConfig` remain (except in old file)
- [x] Application compiles successfully

---

#### Task 1.3: Add Unit Tests
**Estimated Time**: 45 minutes
**Dependencies**: Task 1.1
**Description**: Create comprehensive unit tests for `LLM.Provider` module

**Subtasks**:
- [ ] Create file `test/temporal_cookbook_ui/llm/provider_test.exs`
- [ ] Test `model_for_provider/1`:
  - Valid providers return correct models
  - Invalid providers return nil
  - Case-insensitive handling
- [ ] Test `available_providers/0`:
  - Returns list of all provider names
- [ ] Test `valid_provider?/1`:
  - Returns true for valid providers
  - Returns false for invalid input
  - Handles nil and non-string types
- [ ] Run tests: `mix test test/temporal_cookbook_ui/llm/`
- [ ] Verify 100% code coverage for this module

**Files Created**:
- `test/temporal_cookbook_ui/llm/provider_test.exs`

**Acceptance Criteria**:
- [x] All tests pass
- [x] Tests cover all public functions
- [x] Tests cover edge cases (nil, invalid types)
- [x] Test output shows 100% coverage for `LLM.Provider`

---

#### Task 1.4: Delete Old File and Run Full Test Suite
**Estimated Time**: 15 minutes
**Dependencies**: Tasks 1.1, 1.2, 1.3
**Description**: Remove old `ProviderConfig` module and verify entire app works

**Subtasks**:
- [ ] Delete file `lib/temporal_cookbook_ui/temporal/provider_config.ex`
- [ ] Run full test suite: `mix test`
- [ ] Verify all tests pass
- [ ] Start dev server: `mix phx.server`
- [ ] Manual smoke test:
  - Navigate to pattern detail page
  - Verify provider dropdown loads
  - Verify workflow can be started
- [ ] Commit changes with descriptive message

**Files Deleted**:
- `lib/temporal_cookbook_ui/temporal/provider_config.ex`

**Acceptance Criteria**:
- [x] Old file deleted
- [x] All tests pass (mix test shows 0 failures)
- [x] Dev server starts without errors
- [x] UI functions correctly
- [x] Changes committed to git

**Git Commit Message**:
```
refactor: Extract LLM provider config to separate domain

- Create LLM.Provider module separate from Temporal domain
- Move provider-to-model mapping logic to LLM context
- Update all imports in LiveViews and components
- Add comprehensive unit tests for LLM.Provider
- Delete obsolete Temporal.ProviderConfig module

This separates concerns - Temporal handles orchestration,
LLM handles AI provider configuration.

Part of Phase 1 - Domain Separation
Ref: docs/refactoring/architecture-refactoring-guide.md
```

---

### PHASE 2: Extract Functional Core (3-4 hours)

#### Task 2.1: Create Temporal Query Module
**Estimated Time**: 1 hour
**Dependencies**: None (can run parallel to Phase 1)
**Description**: Create pure functional core for parsing Temporal CLI output

**Subtasks**:
- [ ] Create file `lib/temporal_cookbook_ui/temporal/query.ex`
- [ ] Implement `parse_status/1` function:
  - Handle COMPLETED status
  - Handle FAILED status
  - Handle RUNNING status
  - Default to UNKNOWN for unrecognized output
- [ ] Implement `extract_result/1` function:
  - Find JSON in "Result: {...}" pattern
  - Find JSON anywhere in output as fallback
  - Return empty map if no JSON found
  - Handle Jason.decode errors gracefully
- [ ] Add private helper functions:
  - `find_json_in_output/1`
  - `find_any_json/1`
- [ ] Add comprehensive module documentation
- [ ] Verify module compiles: `mix compile`

**Files Created**:
- `lib/temporal_cookbook_ui/temporal/query.ex`

**Acceptance Criteria**:
- [x] `parse_status/1` handles all status types
- [x] `extract_result/1` handles all JSON patterns
- [x] Functions are pure (no side effects)
- [x] Documentation includes examples
- [x] Code compiles without warnings

---

#### Task 2.2: Add Unit Tests for Query Module
**Estimated Time**: 1 hour
**Dependencies**: Task 2.1
**Description**: Create comprehensive unit tests for `Temporal.Query` module

**Subtasks**:
- [ ] Create file `test/temporal_cookbook_ui/temporal/query_test.exs`
- [ ] Test `parse_status/1`:
  - COMPLETED status (multiple formats)
  - FAILED status (multiple formats)
  - RUNNING status (multiple formats)
  - UNKNOWN for unrecognized input
  - Empty string handling
- [ ] Test `extract_result/1`:
  - JSON with "Result:" prefix
  - JSON anywhere in output
  - No JSON in output (returns empty map)
  - Invalid JSON (returns error tuple)
  - Complex nested JSON structures
- [ ] Run tests: `mix test test/temporal_cookbook_ui/temporal/query_test.exs`
- [ ] Verify 100% coverage

**Files Created**:
- `test/temporal_cookbook_ui/temporal/query_test.exs`

**Acceptance Criteria**:
- [x] All tests pass
- [x] Tests cover all branches
- [x] Edge cases tested (empty, nil, invalid)
- [x] 100% code coverage for `Temporal.Query`

---

#### Task 2.3: Update Temporal Client to Use Query Module
**Estimated Time**: 1 hour
**Dependencies**: Tasks 2.1, 2.2
**Description**: Refactor `Temporal.Client` to use pure `Query` functions

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui/temporal/client.ex`:
  - Add alias: `alias TemporalCookbookUi.Temporal.Query`
  - Remove inline `parse_workflow_status/1` function
  - Remove inline `extract_result_from_cli_output/1` function
  - Create new `describe_workflow/2` function using `Query.parse_status/1`
  - Update `get_workflow_result/2` to use `Query.extract_result/1`
  - Add private helper functions:
    - `build_describe_args/2`
    - `build_show_args/2`
- [ ] Update function documentation
- [ ] Verify module compiles: `mix compile`
- [ ] Run client tests (if any exist)

**Files Modified**:
- `lib/temporal_cookbook_ui/temporal/client.ex`

**Acceptance Criteria**:
- [x] `Client` delegates parsing to `Query` module
- [x] `describe_workflow/2` returns structured data
- [x] `get_workflow_result/2` uses `Query.extract_result/1`
- [x] All System.cmd calls isolated to Client module
- [x] Function signatures clear and documented
- [x] Code compiles without warnings

---

#### Task 2.4: Update ExecutionViewLive to Use New Client API
**Estimated Time**: 45 minutes
**Dependencies**: Task 2.3
**Description**: Refactor LiveView to use new `Client` boundary layer

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui_web/live/execution_view_live.ex`:
  - Remove all inline CLI logic
  - Remove `get_workflow_status/2` function
  - Remove `parse_workflow_status/1` function
  - Remove `extract_result_from_cli_output/1` function
  - Update `handle_info(:poll_workflow)` to use `Client.describe_workflow/2`
  - Simplify result fetching to use `Client.get_workflow_result/2`
- [ ] Verify LiveView compiles: `mix compile`
- [ ] Manual smoke test in browser

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/execution_view_live.ex`

**Acceptance Criteria**:
- [x] No direct System.cmd calls in LiveView
- [x] No parsing logic in LiveView
- [x] Uses `Client.describe_workflow/2`
- [x] Uses `Client.get_workflow_result/2`
- [x] Code is cleaner and easier to read
- [x] UI functions correctly (manual test)

---

#### Task 2.5: Run Full Test Suite and Commit
**Estimated Time**: 15 minutes
**Dependencies**: Tasks 2.1, 2.2, 2.3, 2.4
**Description**: Verify all changes work together and commit Phase 2

**Subtasks**:
- [ ] Run full test suite: `mix test`
- [ ] Verify all tests pass
- [ ] Start dev server: `mix phx.server`
- [ ] Manual end-to-end test:
  - Start a workflow
  - Navigate to execution view
  - Verify status updates (RUNNING → COMPLETED)
  - Verify result displays correctly
- [ ] Commit changes

**Acceptance Criteria**:
- [x] All tests pass
- [x] No compilation warnings
- [x] UI works end-to-end
- [x] Changes committed

**Git Commit Message**:
```
refactor: Extract Temporal query logic to functional core

- Create Temporal.Query module with pure parsing functions
- Move parse_status and extract_result to Query module
- Update Temporal.Client to use Query for parsing
- Refactor ExecutionViewLive to use Client boundary layer
- Remove all CLI parsing logic from LiveView
- Add comprehensive unit tests for Query module

This separates pure business logic (Query) from side effects (Client)
and removes infrastructure concerns from presentation layer (LiveView).

Part of Phase 2 - Extract Functional Core
Ref: docs/refactoring/architecture-refactoring-guide.md
```

---

### PHASE 3: Refactor Boundary Layer (2-3 hours)

**Note**: Most of Phase 3 is completed in Phase 2, Task 2.3. This phase focuses on additional refinements.

#### Task 3.1: Add Error Handling and Logging to Client
**Estimated Time**: 1 hour
**Dependencies**: Phase 2 complete
**Description**: Improve error handling and add structured logging

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui/temporal/client.ex`:
  - Add `require Logger` at top of module
  - Add logging to `start_workflow/4`:
    - Log workflow start attempts
    - Log successful starts with run_id
    - Log errors with details
  - Add logging to `describe_workflow/2`:
    - Log describe attempts
    - Log failures
  - Add logging to `get_workflow_result/2`:
    - Log result fetch attempts
    - Log failures
  - Improve error tuples:
    - Return descriptive error reasons
    - Include relevant context in errors
- [ ] Test error scenarios manually
- [ ] Verify logs appear in dev console

**Files Modified**:
- `lib/temporal_cookbook_ui/temporal/client.ex`

**Acceptance Criteria**:
- [x] All Client functions include logging
- [x] Error tuples are descriptive
- [x] Logs visible in `mix phx.server` output
- [x] Error handling doesn't break functionality

---

#### Task 3.2: Add Client Integration Tests
**Estimated Time**: 1.5 hours
**Dependencies**: Task 3.1
**Description**: Create integration tests for Temporal.Client (optional - may mock)

**Subtasks**:
- [ ] Create file `test/temporal_cookbook_ui/temporal/client_test.exs`
- [ ] Decide on mocking strategy:
  - Option A: Mock System.cmd for unit testing
  - Option B: Integration tests requiring Temporal server
- [ ] Test `start_workflow/4`:
  - Successful workflow start
  - CLI error handling
  - Invalid input handling
- [ ] Test `describe_workflow/2`:
  - Successful describe
  - Workflow not found
- [ ] Test `get_workflow_result/2`:
  - Completed workflow with result
  - Workflow not completed
- [ ] Run tests: `mix test test/temporal_cookbook_ui/temporal/client_test.exs`

**Files Created**:
- `test/temporal_cookbook_ui/temporal/client_test.exs`

**Acceptance Criteria**:
- [x] Integration tests written (or mocked unit tests)
- [x] Tests pass
- [x] Error scenarios covered
- [x] Documentation on how to run tests

**Note**: This task may be deferred if mocking is complex. Integration tests can be added later.

---

#### Task 3.3: Document Client API
**Estimated Time**: 30 minutes
**Dependencies**: Tasks 3.1, 3.2
**Description**: Ensure Client module has excellent documentation

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui/temporal/client.ex`:
  - Enhance module-level @moduledoc
  - Add examples to function docs
  - Document all parameters clearly
  - Document all return types
  - Add @doc for all public functions
  - Add @spec typespecs (optional but recommended)
- [ ] Generate docs: `mix docs`
- [ ] Review generated documentation in browser
- [ ] Verify examples are accurate

**Files Modified**:
- `lib/temporal_cookbook_ui/temporal/client.ex`

**Acceptance Criteria**:
- [x] Module documentation is comprehensive
- [x] All public functions documented
- [x] Examples are accurate and helpful
- [x] Generated docs look professional

---

#### Task 3.4: Commit Phase 3 Changes
**Estimated Time**: 15 minutes
**Dependencies**: Tasks 3.1, 3.2, 3.3
**Description**: Commit Phase 3 improvements

**Subtasks**:
- [ ] Run full test suite: `mix test`
- [ ] Verify all tests pass
- [ ] Check for compilation warnings
- [ ] Commit changes

**Acceptance Criteria**:
- [x] All tests pass
- [x] No warnings
- [x] Changes committed

**Git Commit Message**:
```
refactor: Improve Temporal.Client boundary layer

- Add structured logging to all Client functions
- Improve error handling and error tuples
- Add integration/unit tests for Client module
- Enhance documentation with examples and typespecs
- Document API surface clearly

Part of Phase 3 - Refactor Boundary Layer
Ref: docs/refactoring/architecture-refactoring-guide.md
```

---

### PHASE 4: LiveView CRC Refactoring (4-5 hours)

#### Task 4.1: Extract Helper Functions from PatternDetailLive
**Estimated Time**: 1 hour
**Dependencies**: Phase 2 complete
**Description**: Move reusable helper functions to shared module

**Subtasks**:
- [ ] Create file `lib/temporal_cookbook_ui_web/live/helpers.ex`
- [ ] Move helper functions:
  - `parse_float/1`
  - `parse_integer/1`
- [ ] Add comprehensive documentation
- [ ] Create tests: `test/temporal_cookbook_ui_web/live/helpers_test.exs`
- [ ] Update `pattern_detail_live.ex` to import helpers
- [ ] Remove duplicate helpers from LiveView
- [ ] Verify tests pass: `mix test`

**Files Created**:
- `lib/temporal_cookbook_ui_web/live/helpers.ex`
- `test/temporal_cookbook_ui_web/live/helpers_test.exs`

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`

**Acceptance Criteria**:
- [x] Helpers module created with reusable functions
- [x] Helpers tested independently
- [x] LiveView imports and uses helpers
- [x] No duplicate code

---

#### Task 4.2: Refactor PatternDetailLive for CRC Pattern
**Estimated Time**: 2 hours
**Dependencies**: Task 4.1
**Description**: Apply strict CRC pattern to PatternDetailLive

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`:
  - Organize code with clear CRC comments
  - **Constructor** section:
    - Keep `mount/3` as-is
  - **Reducers** section:
    - Simplify `handle_event("start_workflow")`
    - Extract workflow building to converter
    - Extract navigation to converter
    - Extract error handling to converter
  - **Converters** section (private functions):
    - Create `build_workflow_request/2`
    - Create `generate_workflow_id/0`
    - Create `navigate_to_execution/3`
    - Create `show_error/2`
  - Keep `render/1` as final converter
  - Move data access to bottom
- [ ] Add inline comments explaining CRC flow
- [ ] Verify code compiles: `mix compile`
- [ ] Manual UI test

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`

**Acceptance Criteria**:
- [x] Code organized into clear CRC sections
- [x] Reducers are thin and delegate to converters
- [x] Converters are pure (no side effects)
- [x] Boundary calls isolated to reducers
- [x] Code is more readable
- [x] UI functions correctly

---

#### Task 4.3: Refactor ExecutionViewLive for CRC Pattern
**Estimated Time**: 1.5 hours
**Dependencies**: Phase 2 complete
**Description**: Apply strict CRC pattern to ExecutionViewLive

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui_web/live/execution_view_live.ex`:
  - Organize code with clear CRC comments
  - **Constructor** section:
    - Keep `mount/3`
    - Keep connection check for polling
  - **Reducers** section:
    - Simplify `handle_info(:poll_workflow)`
    - Extract status handling to converters
  - **Converters** section (private functions):
    - Create `extract_run_id/1`
    - Create `fetch_workflow_status/1`
    - Create `fetch_result/2`
    - Create `mark_completed/2`
    - Create `mark_failed/1`
    - Keep `schedule_poll/0`
  - Keep `render/1` as final converter
- [ ] Verify code compiles: `mix compile`
- [ ] Manual UI test (watch workflow progress)

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/execution_view_live.ex`

**Acceptance Criteria**:
- [x] Code organized into clear CRC sections
- [x] Reducers are thin and focused
- [x] Converters handle data transformation
- [x] Polling logic is clean
- [x] UI functions correctly (real-time updates work)

---

#### Task 4.4: Add LiveView Tests
**Estimated Time**: 1.5 hours (optional)
**Dependencies**: Tasks 4.2, 4.3
**Description**: Add comprehensive LiveView tests

**Subtasks**:
- [ ] Create/update `test/temporal_cookbook_ui_web/live/pattern_detail_live_test.exs`:
  - Test mount/3 initialization
  - Test start_workflow event handling
  - Test error handling
  - Test navigation
- [ ] Create/update `test/temporal_cookbook_ui_web/live/execution_view_live_test.exs`:
  - Test mount/3 initialization
  - Test polling behavior
  - Test status transitions
  - Test result display
- [ ] Run tests: `mix test test/temporal_cookbook_ui_web/live/`
- [ ] Verify coverage

**Files Created/Modified**:
- `test/temporal_cookbook_ui_web/live/pattern_detail_live_test.exs`
- `test/temporal_cookbook_ui_web/live/execution_view_live_test.exs`

**Acceptance Criteria**:
- [x] LiveView tests written
- [x] Key user flows tested
- [x] Tests pass
- [x] Good coverage of critical paths

**Note**: This task is optional but highly recommended for production code.

---

#### Task 4.5: Commit Phase 4 Changes
**Estimated Time**: 15 minutes
**Dependencies**: Tasks 4.1, 4.2, 4.3, 4.4
**Description**: Commit Phase 4 refactoring

**Subtasks**:
- [ ] Run full test suite: `mix test`
- [ ] Manual end-to-end testing:
  - Navigate to pattern detail
  - Start workflow
  - Watch execution progress
  - Verify result display
- [ ] Check for warnings: `mix compile --warnings-as-errors`
- [ ] Commit changes

**Acceptance Criteria**:
- [x] All tests pass
- [x] No compilation warnings
- [x] UI works end-to-end
- [x] Changes committed

**Git Commit Message**:
```
refactor: Apply CRC pattern to LiveView modules

- Extract reusable helpers to shared module
- Refactor PatternDetailLive with clear CRC structure
- Refactor ExecutionViewLive with clear CRC structure
- Separate constructors, reducers, and converters
- Add LiveView tests for critical user flows
- Improve code readability and maintainability

Constructors initialize state, Reducers transform state,
Converters format data for rendering. This pattern makes
LiveView logic easier to understand and test.

Part of Phase 4 - LiveView CRC Refactoring
Ref: docs/refactoring/architecture-refactoring-guide.md
```

---

### PHASE 5: Context Layer (3-4 hours) - OPTIONAL

**Note**: This phase is optional and can be deferred to a later PR/feature.

#### Task 5.1: Create LLM Context Module
**Estimated Time**: 1 hour
**Dependencies**: Phase 1 complete
**Description**: Create Phoenix context for LLM domain

**Subtasks**:
- [ ] Create file `lib/temporal_cookbook_ui/llm.ex`
- [ ] Define context module with `@moduledoc`
- [ ] Delegate functions to `LLM.Provider`:
  - `model_for_provider/1`
  - `available_providers/0`
  - `valid_provider?/1`
- [ ] Add context-level documentation
- [ ] Consider adding context-level logic (if any)
- [ ] Verify compiles: `mix compile`

**Files Created**:
- `lib/temporal_cookbook_ui/llm.ex`

**Acceptance Criteria**:
- [x] Context module provides clean API
- [x] Delegates to underlying modules
- [x] Documentation is clear
- [x] Compiles without warnings

---

#### Task 5.2: Update LiveView to Use Context
**Estimated Time**: 30 minutes
**Dependencies**: Task 5.1
**Description**: Update LiveViews to use context instead of direct module access

**Subtasks**:
- [ ] Update `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`:
  - Change: `alias TemporalCookbookUi.LLM.Provider` → `alias TemporalCookbookUi.LLM`
  - Update calls: `Provider.model_for_provider` → `LLM.model_for_provider`
- [ ] Update `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`:
  - Change alias
  - Update function calls
- [ ] Verify compiles: `mix compile`
- [ ] Run tests: `mix test`

**Files Modified**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`
- `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`

**Acceptance Criteria**:
- [x] LiveViews use context API
- [x] No direct module references
- [x] Tests pass
- [x] Code compiles

---

#### Task 5.3: Create Cookbook Context (Future)
**Estimated Time**: 2-3 hours
**Dependencies**: None (future work)
**Description**: Create context for cookbook/pattern domain

**Note**: This is future work for when we have more pattern-related logic.

**Subtasks**:
- [ ] Create `lib/temporal_cookbook_ui/cookbook.ex`
- [ ] Create `lib/temporal_cookbook_ui/cookbook/pattern.ex`
- [ ] Move pattern data access from LiveView to context
- [ ] Add pattern-related business logic
- [ ] Update LiveViews to use Cookbook context
- [ ] Add tests

**Files Created**:
- `lib/temporal_cookbook_ui/cookbook.ex`
- `lib/temporal_cookbook_ui/cookbook/pattern.ex`

**Acceptance Criteria**:
- [x] Context provides pattern operations
- [x] Pattern data separated from presentation
- [x] Tests added
- [x] LiveViews updated

---

#### Task 5.4: Commit Phase 5 Changes
**Estimated Time**: 15 minutes
**Dependencies**: Tasks 5.1, 5.2
**Description**: Commit Phase 5 (context layer)

**Subtasks**:
- [ ] Run full test suite: `mix test`
- [ ] Verify all tests pass
- [ ] Manual smoke test
- [ ] Commit changes

**Acceptance Criteria**:
- [x] Tests pass
- [x] UI works
- [x] Changes committed

**Git Commit Message**:
```
refactor: Add Phoenix context layer for LLM domain

- Create LLM context module with clean API
- Update LiveViews to use context instead of direct modules
- Improve abstraction and future extensibility
- Maintain backward compatibility

Context layer provides high-level API for domain operations,
making it easier to change underlying implementation without
affecting presentation layer.

Part of Phase 5 - Context Layer (Optional)
Ref: docs/refactoring/architecture-refactoring-guide.md
```

---

## Summary of Deliverables

### Phase 1 (Required)
- [x] New module: `lib/temporal_cookbook_ui/llm/provider.ex`
- [x] New test: `test/temporal_cookbook_ui/llm/provider_test.exs`
- [x] Modified: `pattern_detail_live.ex`, `workflow_controls.ex`
- [x] Deleted: `lib/temporal_cookbook_ui/temporal/provider_config.ex`

### Phase 2 (Required)
- [x] New module: `lib/temporal_cookbook_ui/temporal/query.ex`
- [x] New test: `test/temporal_cookbook_ui/temporal/query_test.exs`
- [x] Modified: `temporal/client.ex`, `execution_view_live.ex`

### Phase 3 (Required)
- [x] Modified: `temporal/client.ex` (logging, errors, docs)
- [x] New test: `test/temporal_cookbook_ui/temporal/client_test.exs` (optional)

### Phase 4 (Required)
- [x] New module: `lib/temporal_cookbook_ui_web/live/helpers.ex`
- [x] New test: `test/temporal_cookbook_ui_web/live/helpers_test.exs`
- [x] Modified: `pattern_detail_live.ex`, `execution_view_live.ex`
- [x] New tests: LiveView tests (optional)

### Phase 5 (Optional - Can Defer)
- [ ] New module: `lib/temporal_cookbook_ui/llm.ex`
- [ ] Modified: LiveViews to use contexts
- [ ] Future: Cookbook context

## Testing Strategy

After each phase:
1. Run `mix test` - all tests must pass
2. Run `mix compile --warnings-as-errors` - no warnings
3. Start dev server: `mix phx.server`
4. Manual smoke test of affected features
5. Commit with descriptive message

## Estimated Timeline

| Phase | Time Estimate | Priority |
|-------|---------------|----------|
| Phase 1 | 2-3 hours | High |
| Phase 2 | 3-4 hours | High |
| Phase 3 | 2-3 hours | Medium |
| Phase 4 | 4-5 hours | Medium |
| Phase 5 | 3-4 hours | Low (Optional) |
| **Total** | **14-19 hours** | |

## Notes

- Each phase can be completed and committed independently
- Phases 1-4 should be done as part of Feature 2
- Phase 5 can be deferred to a separate PR if desired
- All existing functionality must continue to work
- No breaking changes to UI/UX
- Focus on code quality and maintainability
