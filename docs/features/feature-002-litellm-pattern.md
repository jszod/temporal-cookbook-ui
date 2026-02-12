# Feature PRD: Feature 002 - LiteLLM Pattern

**GitHub Issue**: #2
**Status**: In Progress - Core Implementation Complete (60%)
**Priority**: High
**Implementation Tasks**: [tasks-002-litellm-pattern.md](tasks/tasks-002-litellm-pattern.md)
**Related ADR**: [001-shared-worker-architecture.md](../decisions/001-shared-worker-architecture.md)
**Last Updated**: 2025-11-25 (Session 006: Added infrastructure status requirements, implementation deferred)

---

## 1. Introduction/Overview

### Feature Description
Implement the first complete Temporal AI Cookbook pattern - LiteLLM - as a vertical slice from Python worker through Phoenix UI. This feature establishes the foundation for all subsequent pattern implementations, including Temporal client integration, real-time workflow visualization, and multi-provider LLM support.

### Problem Statement
Developers learning Temporal AI patterns need a way to:
- Run AI workflows with real LLM providers (OpenAI, Anthropic, Groq, Ollama) without writing code
- See how Temporal orchestrates LLM calls with retry behavior and error handling
- Understand multi-provider flexibility through interactive experimentation
- Learn Temporal patterns through hands-on interaction rather than static documentation

Currently, the UI has placeholder pages but no actual workflow execution capability. This feature bridges that gap by implementing a complete end-to-end flow.

### Connection to Project Goals
This feature directly supports the project's core value proposition: transforming Temporal learning from static docs to interactive visual exploration. It establishes the technical foundation (Temporal client integration, worker architecture, real-time visualization) that all subsequent patterns will build upon. The LiteLLM pattern is chosen as the first implementation because it's the simplest AI pattern, providing a clean foundation for more complex patterns later.

---

## 2. Goals

### Primary Objectives
- **Complete Vertical Slice**: Implement LiteLLM pattern from Python worker through Phoenix UI with real Temporal integration
- **Multi-Provider Support**: Enable switching between OpenAI, Anthropic, Groq, and Ollama providers through UI
- **Real-Time Visualization**: Display workflow execution status and LLM responses as they occur
- **Production-Realistic Architecture**: Use shared worker pattern (one worker registering all 7 workflows) matching production Temporal usage
- **Foundation for Future Patterns**: Establish reusable components and patterns for Features 3-7

### Success Criteria
- User can start LiteLLM workflow from UI with any provider (OpenAI, Anthropic, Groq, Ollama)
- Worker runs as single process registering all 7 workflows (Temporal-standard pattern)
- Workflow execution visible in real-time with LLM response displayed
- Worker status visible in UI (online/offline indicator)
- Manual worker control documented in UI
- Architecture matches production Temporal patterns (see ADR 001)

---

## 3. User Stories

### User Story 1: Run LiteLLM Workflow
**As a** developer learning Temporal AI patterns
**I want to** run a LiteLLM workflow with my choice of LLM provider
**So that** I can see how Temporal orchestrates AI operations without writing code

**Acceptance Criteria**:
- [ ] I can select a provider from dropdown (OpenAI, Anthropic, Groq, Ollama)
- [ ] I can enter a custom prompt in a text area
- [ ] I can adjust temperature and max_tokens parameters
- [ ] I can click "Run Workflow" to start execution
- [ ] I see the workflow ID and execution status immediately
- [ ] I am redirected to execution view showing real-time progress

### User Story 2: View Workflow Execution
**As a** developer exploring Temporal patterns
**I want to** see my workflow execute in real-time
**So that** I understand how Temporal handles LLM calls, retries, and responses

**Acceptance Criteria**:
- [ ] I see workflow status (Running/Completed/Failed) updating in real-time
- [ ] I see the LLM response when workflow completes
- [ ] I see token usage and latency metrics
- [ ] I can see basic event timeline (enhanced in Feature 7)
- [ ] I can navigate back to pattern detail page

### User Story 3: Understand Infrastructure Status
**As a** developer learning production Temporal patterns
**I want to** see Temporal Server and worker status to understand system health
**So that** I learn the correct Temporal architecture (workers as infrastructure) and can debug issues

**Acceptance Criteria**:
- [ ] I see Temporal Server status indicator in navbar (🟢 Online / 🔴 Offline)
- [ ] I see worker count indicator in navbar (e.g., "🟢 3 Online" or "🔴 0 Online")
- [ ] I see instructions for manually controlling workers
- [ ] I understand that workers are infrastructure, not UI-controlled
- [ ] I can demonstrate failure recovery by stopping/starting workers manually
- [ ] I can see when multiple workers are running (production-realistic scenario)

---

## 4. Functional Requirements

### Core Functionality

1. **Python Worker Implementation** (Language-specific directory structure - flat organization):
   - **Multi-language organization**: Python code in `python/` directory (Elixir in `lib/`, Go in `go/` for future)
   - Standard Temporal layout within `python/`: `workflows/`, `activities/`, `worker/`
   - **Flat structure**: All workflows in `python/workflows/`, all activities in `python/activities/` (no subdirectories per pattern)
   - Single worker process registering all 7 cookbook workflows
   - LiteLLM workflow implementation (adapted from Temporal AI Cookbook)
   - LiteLLM activity implementation with multi-provider support (OpenAI, Anthropic, Groq, Ollama)
   - Task queue: `temporal-cookbook-examples`
   - Worker can be started manually: `cd python && uv run python worker/main.py` (using uv for environment management)

2. **Temporal Client Integration**:
   - Elixir Temporal gRPC client wrapper for workflow operations
   - Start workflow functionality with input parameters
   - Retrieve workflow history and events
   - Query workflow state
   - Real-time event subscription for LiveView updates

3. **Phoenix UI Components**:
   - Enhanced PatternDetailLive with LiteLLM-specific controls
   - Model selector dropdown (OpenAI, Anthropic, Groq, Ollama)
   - Prompt input textarea with validation
   - Temperature slider (0.0 - 2.0, default 0.7)
   - Max tokens input field (default 500)
   - "Run Workflow" button with loading state
   - Worker status component in navbar

4. **Execution Visualization**:
   - ExecutionViewLive showing workflow status
   - Real-time status updates (Running/Completed/Failed)
   - LLM response display with formatting
   - Token usage and latency metrics
   - Basic event timeline (full visualization in Feature 7)

5. **Infrastructure Status Monitoring**:
   - **Temporal Server Health Check**: Ping gRPC endpoint (localhost:7233) to verify server connectivity
   - **Worker Health Check**: Query Temporal DescribeTaskQueue API to count active workers polling the task queue
   - **UI Status Display**: Show both Temporal Server status and worker count in navbar
   - **Multi-Worker Support**: Display count of active workers (e.g., "3 Online" or "0 Online")
   - **Real-time Updates**: Poll status every 5-10 seconds and update UI accordingly
   - **Demo Instructions**: Tooltip or info icon with worker management instructions

### User Interactions
- **Provider Selection**: User selects LLM provider from dropdown
- **Prompt Input**: User enters custom prompt text
- **Parameter Adjustment**: User adjusts temperature and max_tokens
- **Workflow Launch**: User clicks "Run Workflow" button
- **Status Monitoring**: User views real-time execution status
- **Result Review**: User views LLM response and metrics

### Data Requirements
- **Workflow Input**: Provider name, prompt text, temperature, max_tokens
- **Workflow Output**: LLM response text, token usage, latency, cost estimate
- **Workflow Events**: Temporal event history for visualization
- **Temporal Server Status**: Online/offline state from gRPC health check
- **Worker Status**: Count of active workers from DescribeTaskQueue API

---

## 5. Non-Goals

### Explicitly Out of Scope
- UI buttons to start/stop workers (workers are infrastructure - see ADR 001)
- Per-pattern worker processes (one worker handles all - see ADR 001)
- Full timeline visualization with Mermaid.js (basic implementation only - enhanced in Feature 7)
- Go worker implementation (Python only for Feature 2)
- OTP worker supervision (manual control for Feature 2, optional in Feature 5)
- Cost calculation accuracy (show estimates only)
- Workflow history persistence (ephemeral for MVP)
- Multi-workflow concurrent execution (one at a time for Feature 2)

### Future Considerations
- Enhanced timeline visualization with Mermaid.js diagrams (Feature 7)
- Go worker implementation for cross-language demonstration (Feature 4+)
- OTP supervision for automatic worker management (Feature 5)
- Workflow history export functionality
- Concurrent workflow execution support

---

## 6. Design Considerations

### User Interface

**Pattern Detail Page** (`/patterns/litellm`):
- Left panel: Pattern description, use case, code snippet (collapsible)
- Right panel: Workflow controls
  - Model selector dropdown (OpenAI, Anthropic, Groq, Ollama)
  - Prompt textarea (multi-line, placeholder text)
  - Temperature slider with value display
  - Max tokens input (number field)
  - "Run Workflow" button (primary CTA)

**Execution View** (`/patterns/litellm/executions/:workflow_id`):
- Status bar: Workflow ID, status badge (Running/Completed/Failed)
- LLM Response section: Formatted text display
- Metrics section: Token count, latency, estimated cost
- Basic event timeline (scrollable list)
- Back navigation to pattern detail

**Navbar**:
- Temporal Server status indicator: 🟢 Online / 🔴 Offline
- Worker count indicator: 🟢 N Online / 🔴 0 Online (where N = number of active workers)
- Tooltip or info icon with infrastructure management instructions
- Example display: "Temporal: 🟢 Online | Workers: 🟢 3 Online"

### Mockups/Wireframes
See Feature 001 wireframes for layout structure. This feature implements the functionality behind those wireframes.

### Interaction Flow
```
1. User navigates to /patterns/litellm
2. User selects provider from dropdown (e.g., "OpenAI")
3. User enters prompt: "Write a haiku about Temporal"
4. User adjusts temperature to 0.8
5. User clicks "Run Workflow" button
6. System generates workflow ID and starts workflow via Temporal client
7. User is redirected to /patterns/litellm/executions/{workflow_id}
8. Execution view shows "Running" status
9. System polls Temporal for workflow updates
10. When workflow completes, LLM response appears with metrics
11. User sees token usage, latency, and formatted response
```

### Accessibility
- Form labels associated with inputs
- Keyboard navigation for all controls
- ARIA labels for status indicators
- Error messages clearly displayed
- Loading states announced to screen readers

---

## 7. Technical Considerations

### Dependencies
- **Temporal Python SDK**: For worker implementation and workflow/activity definitions
- **LiteLLM Library**: For multi-provider LLM support
- **Temporal Elixir Client**: For Phoenix integration (tortoise, temporalio/sdk-elixir, or direct gRPC)
- **Temporal Dev Server**: Local Temporal server for workflow orchestration
- **LLM Provider APIs**: OpenAI, Anthropic, Groq API keys (or Ollama for local testing)

### Integration Points
- **PatternDetailLive**: Enhance existing placeholder with LiteLLM controls
- **ExecutionViewLive**: Implement real workflow visualization (currently placeholder)
- **Temporal Client**: New module for Temporal gRPC operations
- **Infrastructure Status Component**: New component for navbar integration (Temporal Server + Worker status)
- **Router**: No changes needed (routes already defined in Feature 001)

### Constraints
- **Worker Architecture**: Must use shared worker pattern (one worker, all 7 workflows) per ADR 001
- **Manual Worker Control**: Workers are infrastructure, not UI-controlled
- **Real-Time Updates**: Must use LiveView subscriptions for workflow status updates
- **Provider API Keys**: Users must configure API keys (or use Ollama for local testing)

### Design Decisions

#### Provider Mapping Location
**Decision**: Provider-to-model mapping is implemented in Elixir/Phoenix UI layer, not in Python worker.

**Rationale**:
- UI controls the provider dropdown - it should own the provider→model mapping
- Python worker stays simpler - just receives model strings (more flexible)
- Single source of truth for UI configuration
- Python code doesn't need to know about "providers" - just model strings

**Data Flow**:
1. UI collects: provider name (e.g., "openai"), prompt, temperature, max_tokens
2. UI maps provider → model string (e.g., "openai" → "gpt-3.5-turbo") using `ProviderConfig`
3. UI sends workflow input: model string, messages, temperature, max_tokens
4. Python workflow receives model string directly
5. Python activity receives `LiteLLMRequest` with model string and calls LiteLLM

**Implementation**:
- Provider configuration module: `lib/temporal_cookbook_ui/temporal/provider_config.ex`
- Workflow controls component: `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`
- Python activity accepts any LiteLLM model string - no provider logic needed

### Files to Modify/Create

**Python Worker** (Language-specific directory structure - flat organization):
- **Structure Decision**: Language-specific directories (`python/`) with flat structure (all workflows in `python/workflows/`, all activities in `python/activities/`) for multi-language project organization
- **Naming Convention**: Workflow files use `_workflow.py` suffix (e.g., `litellm_workflow.py`) following Temporal Python SDK idiomatic conventions
- `python/workflows/__init__.py` - Workflow registry importing all 7 workflow types
- `python/workflows/litellm_workflow.py` - LiteLLM workflow implementation
- `python/workflows/tool_calling_workflow.py` - Placeholder for Feature 4
- `python/workflows/structured_outputs_workflow.py` - Placeholder for Feature 4
- `python/workflows/retry_policy_workflow.py` - Placeholder for Feature 5
- `python/workflows/durable_agent_workflow.py` - Placeholder for Feature 6
- `python/workflows/deep_research_workflow.py` - Placeholder for Feature 7
- `python/activities/__init__.py` - Activity registry importing all activities
- `python/activities/litellm.py` - LiteLLM activity with multi-provider support
- `python/worker/main.py` - Worker run script (registers all workflows/activities, runs worker)
- `python/pyproject.toml` - Python project configuration and dependencies (using uv)
- `python/uv.lock` - Lock file for reproducible dependencies (generated by uv)

**Elixir/Phoenix** (new/modify):
- `lib/temporal_cookbook_ui/temporal/client.ex` - Temporal gRPC client wrapper (new)
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex` - Enhance with LiteLLM controls (modify)
- `lib/temporal_cookbook_ui_web/live/execution_view_live.ex` - Implement visualization (modify)
- `lib/temporal_cookbook_ui_web/components/infrastructure_status.ex` - Infrastructure status component (Temporal Server + Workers) (new)
- `lib/temporal_cookbook_ui_web/components/workflow_controls.ex` - Workflow input controls (new)

**Documentation** (new/modify):
- `docs/decisions/001-shared-worker-architecture.md` - ADR (new, already created)
- `docs/features/feature-002-litellm-pattern.md` - This PRD (new)
- `docs/tasks/tasks-002-litellm-pattern.md` - Task breakdown (new)
- `docs/PLAN.md` - Update Feature 2 and Feature 5 scope (modify)
- `docs/PRD.md` - Update worker management section (modify)

---

## 8. Success Metrics

### Measurement Criteria
- **Workflow Launch Success Rate**: 95%+ workflows start successfully from UI
- **Real-Time Update Latency**: < 200ms delay for workflow status updates
- **Provider Support**: All 4 providers (OpenAI, Anthropic, Groq, Ollama) functional
- **Temporal Server Status Accuracy**: Health check correctly identifies server online/offline state
- **Worker Status Accuracy**: Health check correctly counts active workers (supports 0-N workers)
- **User Experience**: User can complete full workflow (launch → view execution → see result) in < 30 seconds

### Testing Strategy
- **Unit Tests**: 
  - Temporal client wrapper functions (start workflow, get history, query state)
  - Temporal Server health check logic (gRPC connection test)
  - Worker status health check logic (DescribeTaskQueue API)
  - Workflow input validation
- **Integration Tests**:
  - End-to-end workflow execution (UI → Phoenix → Temporal → Worker → Response)
  - Temporal Server status updates when server stops/starts
  - Worker status updates when workers stop/start (test with 0, 1, and multiple workers)
  - Multi-provider workflow execution
- **Manual Testing**:
  - Test with all 4 providers (OpenAI, Anthropic, Groq, Ollama)
  - Test Temporal Server failure/recovery demonstration
  - Test worker failure/recovery demonstration (single and multiple workers)
  - Test error handling (invalid API keys, network failures)

### Definition of Done
- [ ] All acceptance criteria met
- [ ] Python worker registers all 7 workflows (6 placeholders, 1 full LiteLLM)
- [ ] LiteLLM workflow works with all 4 providers
- [ ] Temporal client integration functional
- [ ] UI controls implemented and functional
- [ ] Real-time execution visualization working
- [ ] Infrastructure status monitoring operational (Temporal Server + Workers)
- [ ] Tests written and passing
- [ ] Documentation updated (PRD, PLAN, ADR)
- [ ] Manual testing completed with all providers

---

## 9. Open Questions

### Clarifications Needed
- [x] Worker architecture decision (resolved: shared worker per ADR 001)
- [x] Infrastructure status display (resolved: show both Temporal Server and Worker count)
- [ ] Elixir Temporal client library selection (tortoise vs temporalio/sdk-elixir vs direct gRPC)
- [ ] Temporal Server health check mechanism (gRPC ping vs connection test)
- [ ] Worker health check mechanism (DescribeTaskQueue API vs polling workflow execution)

### Decisions Pending
- [ ] Temporal client library choice (to be determined during implementation)
- [ ] Temporal Server health check implementation approach (gRPC ping recommended)
- [ ] Worker health check implementation approach (DescribeTaskQueue API recommended for accurate count)

---

## Implementation Timeline

**Estimated Effort**: 5 days
**Target Completion**: End of Week 3 (per PLAN.md)
**Milestone**: MVP Features

---

## References

- **Main PRD**: docs/PRD.md
- **Development Plan**: docs/PLAN.md
- **Related ADR**: docs/decisions/001-shared-worker-architecture.md
- **GitHub Issue**: #2
- **Temporal AI Cookbook**: https://docs.temporal.io/ai-cookbook
- **LiteLLM Documentation**: https://docs.litellm.ai/
- **Temporal Python SDK**: https://docs.temporal.io/dev-guide/python

---

**Created**: 2025-11-24
**Last Updated**: 2025-11-25
**Next Review**: After Feature 002 completion

---

## 8. Implementation Status

**Last Updated**: 2025-11-25 (Session 006)  
**Detailed Task Tracking**: See [tasks-002-litellm-pattern.md](tasks/tasks-002-litellm-pattern.md) for complete task breakdown

### ✅ Completed (Core Implementation - ~60%)
- **Python Worker Infrastructure**: Worker main script, workflow and activity registration
- **LiteLLM Activity**: Multi-provider support with proper error handling and retry configuration
- **LiteLLM Workflow**: Complete workflow implementation with response parsing
- **UI Components**: WorkflowControls component for input, ExecutionViewLive for results
- **Temporal Client**: CLI bridge implementation for starting workflows
- **Provider Configuration**: ProviderConfig module for provider-to-model mapping
- **Ollama Support**: Configured and tested with gemma3:latest model
- **Real-time Updates**: Workflow status polling and result display
- **Documentation**: PRD and tasks updated with infrastructure status requirements

### 🔄 In Progress
- **Provider Testing**: Ollama ✅, OpenAI ⏳ (needs API key), Anthropic/Groq pending
- **Infrastructure Status Component**: Requirements documented, implementation deferred (see Session 006 notes)

### 📋 Remaining (Per Task Breakdown)
- **Task 4.0**: Infrastructure status component implementation (Temporal Server + Worker count)
- **Task 5.7**: Comprehensive testing across all providers (OpenAI, Anthropic, Groq)
- **Task 5.0**: Unit and integration tests
- **Task 6.0**: Final documentation updates and code review

### 🐛 Known Issues
- Worker must be manually started (by design per ADR 001)
- Temporal client uses CLI bridge (can be upgraded to gRPC later)
- OpenAI API key configuration needed for full testing
- Infrastructure status component implementation deferred - architecture needs refinement (see [Session 006 notes](../sessions/session-006-feature-002-documentation-updates.md))

