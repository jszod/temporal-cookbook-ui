# Implementation Tasks: Feature 002 - LiteLLM Pattern

**Feature PRD**: docs/features/feature-002-litellm-pattern.md
**GitHub Issue**: #2
**Status**: In Progress
**Last Updated**: 2025-11-24

---

## Relevant Files

### Files to Create

**Python Worker** (Language-specific directory structure - flat organization):
- **Structure Decision**: Language-specific directories (`python/`) with flat structure (all workflows in `python/workflows/`, all activities in `python/activities/`) for multi-language project organization
- `python/workflows/__init__.py` - Workflow registry importing all 7 workflow types
- `python/workflows/litellm.py` - LiteLLM workflow implementation
- `python/workflows/tool_calling.py` - Placeholder for Feature 4
- `python/workflows/structured_outputs.py` - Placeholder for Feature 4
- `python/workflows/retry_policy.py` - Placeholder for Feature 5
- `python/workflows/durable_agent.py` - Placeholder for Feature 6
- `python/workflows/deep_research.py` - Placeholder for Feature 7
- `python/activities/__init__.py` - Activity registry importing all activities
- `python/activities/litellm.py` - LiteLLM activity with multi-provider support
- `python/worker/main.py` - Worker run script (registers all workflows/activities, runs worker)
- `python/requirements.txt` - Python dependencies (temporalio, litellm, etc.)

**Elixir/Phoenix**:
- `lib/temporal_cookbook_ui/temporal/client.ex` - Temporal gRPC client wrapper
- `lib/temporal_cookbook_ui_web/components/worker_status.ex` - Worker status LiveComponent
- `lib/temporal_cookbook_ui_web/components/workflow_controls.ex` - Workflow input controls LiveComponent

**Documentation**:
- `docs/decisions/001-shared-worker-architecture.md` - ADR (already created)
- `docs/features/feature-002-litellm-pattern.md` - Feature PRD (already created)
- `docs/tasks/tasks-002-litellm-pattern.md` - This file (already created)

### Files to Modify

- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex` - Enhance with LiteLLM controls
- `lib/temporal_cookbook_ui_web/live/execution_view_live.ex` - Implement real workflow visualization
- `lib/temporal_cookbook_ui_web/components/layouts/root.html.heex` - Add worker status to navbar
- `mix.exs` - Add Temporal client dependency (if using library)
- `docs/PLAN.md` - Update Feature 2 and Feature 5 scope
- `docs/PRD.md` - Update worker management section

---

## Implementation Tasks

### Setup
- [x] **0.0 Create feature branch**
  - Branch name: `feature/2-litellm-pattern`
  - Base: `main`
  - Command: `git checkout -b feature/2-litellm-pattern`

### Documentation
- [x] **1.0 Create architectural documentation**
  - [x] **1.1** Create ADR 001 documenting shared worker architecture decision
  - [x] **1.2** Create Feature 002 PRD with complete specification
  - [x] **1.3** Create detailed task breakdown (this file)

### Python Worker Foundation
- [ ] **2.0 Create Python worker structure (Language-specific directory - flat organization)**
  - [ ] **2.1** Create `python/` directory at project root (language-specific directory for Python code)
  - [ ] **2.2** Create `python/workflows/` directory (flat structure - all workflows in one folder)
  - [ ] **2.3** Create `python/activities/` directory (flat structure - all activities in one folder)
  - [ ] **2.4** Create `python/worker/` directory
  - [ ] **2.5** Create `python/workflows/__init__.py` importing all 7 workflow types
  - [ ] **2.6** Create placeholder workflow files for 6 future patterns in `python/workflows/` (tool_calling.py, structured_outputs.py, retry_policy.py, durable_agent.py, deep_research.py, plus one more)
  - [ ] **2.7** Create `python/activities/__init__.py` for activity registry
  - [ ] **2.8** Create `python/requirements.txt` with dependencies (temporalio, litellm)

- [ ] **2.9 Implement LiteLLM workflow**
  - [ ] **2.9.1** Create `python/workflows/litellm.py` with workflow definition
  - [ ] **2.9.2** Implement workflow function accepting provider, prompt, temperature, max_tokens
  - [ ] **2.9.3** Add workflow execution logic calling LiteLLM activity
  - [ ] **2.9.4** Add error handling and retry logic

- [ ] **2.10 Implement LiteLLM activity**
  - [ ] **2.10.1** Create `python/activities/litellm.py` with activity definition
  - [ ] **2.10.2** Implement activity function with multi-provider support (OpenAI, Anthropic, Groq, Ollama)
  - [ ] **2.10.3** Add provider configuration and API key handling
  - [ ] **2.10.4** Add response parsing (text, tokens, latency)
  - [ ] **2.10.5** Add error handling for API failures

- [ ] **2.11 Create worker main script**
  - [ ] **2.11.1** Create `python/worker/main.py` with worker initialization
  - [ ] **2.11.2** Register all 7 workflows in worker (6 placeholders, 1 full LiteLLM)
  - [ ] **2.11.3** Register all activities in worker
  - [ ] **2.11.4** Configure task queue: `temporal-cookbook-examples`
  - [ ] **2.11.5** Add worker.run() with proper error handling
  - [ ] **2.11.6** Test worker manually: `python python/worker/main.py` (or `cd python && python worker/main.py`)

- [ ] **2.12 Verify worker functionality**
  - [ ] **2.12.1** Verify worker connects to Temporal Dev Server
  - [ ] **2.12.2** Test LiteLLM workflow execution manually (using Temporal CLI or Python script)
  - [ ] **2.12.3** Test with all 4 providers (OpenAI, Anthropic, Groq, Ollama)
  - [ ] **2.12.4** Verify error handling for invalid API keys

### Temporal Client Integration
- [ ] **3.0 Research and select Elixir Temporal client**
  - [ ] **3.1** Research available options: tortoise, temporalio/sdk-elixir, direct gRPC
  - [ ] **3.2** Evaluate pros/cons of each option
  - [ ] **3.3** Select client library (or decide on direct gRPC approach)
  - [ ] **3.4** Add dependency to `mix.exs` if using library

- [ ] **3.5 Implement Temporal client wrapper**
  - [ ] **3.5.1** Create `lib/temporal_cookbook_ui/temporal/client.ex`
  - [ ] **3.5.2** Implement client initialization and connection
  - [ ] **3.5.3** Implement `start_workflow/4` function (workflow_type, workflow_id, input, options)
  - [ ] **3.5.4** Implement `get_workflow_history/2` function (workflow_id, run_id)
  - [ ] **3.5.5** Implement `query_workflow_state/2` function (workflow_id, run_id)
  - [ ] **3.5.6** Implement `get_workflow_result/2` function (workflow_id, run_id)
  - [ ] **3.5.7** Add error handling for connection failures, timeouts
  - [ ] **3.5.8** Test client functions manually (IEx console)

- [ ] **3.6 Implement real-time event subscription**
  - [ ] **3.6.1** Research Temporal event streaming options
  - [ ] **3.6.2** Implement polling mechanism for workflow status updates
  - [ ] **3.6.3** Create GenServer or Task for background polling
  - [ ] **3.6.4** Integrate with Phoenix PubSub for LiveView updates

### Phoenix UI Components
- [ ] **4.0 Create worker status component**
  - [ ] **4.1** Create `lib/temporal_cookbook_ui_web/components/worker_status.ex` LiveComponent
  - [ ] **4.2** Implement health check mechanism (poll Temporal task queue or worker heartbeat)
  - [ ] **4.3** Add status state (online/offline) with visual indicator (🟢/🔴)
  - [ ] **4.4** Add tooltip or info icon with worker management instructions
  - [ ] **4.5** Integrate into navbar layout (`root.html.heex`)

- [ ] **4.6 Create workflow controls component**
  - [ ] **4.6.1** Create `lib/temporal_cookbook_ui_web/components/workflow_controls.ex` LiveComponent
  - [ ] **4.6.2** Implement model selector dropdown (OpenAI, Anthropic, Groq, Ollama)
  - [ ] **4.6.3** Implement prompt textarea with validation
  - [ ] **4.6.4** Implement temperature slider (0.0-2.0, default 0.7) with value display
  - [ ] **4.6.5** Implement max tokens input field (default 500) with validation
  - [ ] **4.6.6** Add "Run Workflow" button with loading state
  - [ ] **4.6.7** Add form validation and error messages

- [ ] **4.7 Enhance PatternDetailLive**
  - [ ] **4.7.1** Update `pattern_detail_live.ex` to handle "litellm" pattern_id
  - [ ] **4.7.2** Integrate WorkflowControls component for LiteLLM pattern
  - [ ] **4.7.3** Update `handle_event("start_workflow", ...)` to call Temporal client
  - [ ] **4.7.4** Generate workflow ID and start workflow via Temporal client
  - [ ] **4.7.5** Handle workflow start errors gracefully
  - [ ] **4.7.6** Navigate to execution view on successful start

- [ ] **4.8 Implement ExecutionViewLive**
  - [ ] **4.8.1** Update `execution_view_live.ex` to fetch workflow data
  - [ ] **4.8.2** Implement workflow status polling (Running/Completed/Failed)
  - [ ] **4.8.3** Display workflow ID and status badge
  - [ ] **4.8.4** Implement LLM response display with formatting
  - [ ] **4.8.5** Display token usage and latency metrics
  - [ ] **4.8.6** Implement basic event timeline (scrollable list of events)
  - [ ] **4.8.7** Add real-time updates via LiveView subscriptions
  - [ ] **4.8.8** Handle workflow errors and display error messages
  - [ ] **4.8.9** Add "Run Again" button linking back to pattern detail

### Testing & Quality
- [ ] **5.0 Write comprehensive tests**
  - [ ] **5.1** Unit tests for Temporal client wrapper functions
  - [ ] **5.2** Unit tests for worker status health check logic
  - [ ] **5.3** Unit tests for workflow input validation
  - [ ] **5.4** Integration tests for end-to-end workflow execution
  - [ ] **5.5** Integration tests for worker status updates
  - [ ] **5.6** All tests passing

- [ ] **5.7 Manual testing**
  - [ ] **5.7.1** Test with OpenAI provider
  - [ ] **5.7.2** Test with Anthropic provider
  - [ ] **5.7.3** Test with Groq provider
  - [ ] **5.7.4** Test with Ollama (local) provider
  - [ ] **5.7.5** Test worker failure/recovery demonstration
  - [ ] **5.7.6** Test error handling (invalid API keys, network failures)

### Documentation & Integration
- [ ] **6.0 Documentation and cleanup**
  - [ ] **6.1** Update `docs/PLAN.md` to reflect shared worker approach
  - [ ] **6.2** Update `docs/PLAN.md` Feature 5 scope (make OTP supervision optional)
  - [ ] **6.3** Update `docs/PRD.md` worker management section
  - [ ] **6.4** Add code comments for complex logic
  - [ ] **6.5** Create README section for worker setup instructions
  - [ ] **6.6** Ensure code follows project style guide (mix format)

### Review & Merge
- [ ] **7.0 Prepare for review**
  - [ ] **7.1** Self-review all changes
  - [ ] **7.2** Verify all acceptance criteria met
  - [ ] **7.3** Create pull request with description
  - [ ] **7.4** Address review feedback
  - [ ] **7.5** Merge to main branch

---

## Task Generation Process

**Generated from**: Feature 002 PRD and implementation plan
**Generation method**: AI-assisted breakdown based on PRD requirements
**Complexity estimate**: Complex (5 days, multiple components)
**Estimated effort**: 5 days

---

## Progress Tracking

### Completed Tasks Summary
- **Total tasks**: 47
- **Completed**: 3 (setup and documentation)
- **Remaining**: 44
- **Progress**: 6%

### Current Focus
Python Worker Foundation - Creating worker structure and implementing LiteLLM workflow and activity

### Blockers
None currently

### Notes & Decisions
- **ADR 001**: Shared worker architecture decision documented (one worker, all 7 workflows)
- **Multi-Language Structure**: Language-specific directories chosen - Python in `python/`, Elixir in `lib/`, Go in `go/` (future). Rationale: Clear separation for polyglot project, each language manages own dependencies, scales well.
- **Flat Organization**: Within each language, flat structure - all workflows in `python/workflows/`, all activities in `python/activities/` (no subdirectories per pattern). Rationale: Simple, maintainable for 7 patterns.
- **Integration Approach**: Hybrid - copy cookbook code initially, then maintain independently. Document source in comments/README.
- Feature PRD created with complete specification
- Task breakdown complete, ready for implementation

---

## Integration with TodoWrite

During actual implementation sessions, use TodoWrite for micro-task planning:

**TodoWrite Example** (real-time session tracking):
```
✓ Creating Python worker structure
  - Set up directory structure
  - Create __init__.py files
  - Add requirements.txt
  - Test module imports
```

**This file** (permanent task record):
- Tracks overall feature progress
- Version controlled alongside code
- Shows what was planned vs. what was done

