# Development Plan - Temporal AI Cookbook UI

**Last Updated**: 2025-11-24
**Current Phase**: MVP Development (Feature 1 Complete)
**Project Focus**: Interactive playground for Temporal AI Cookbook patterns
**Timeline**: 6-8 weeks to MVP

## Project Scope

Building an interactive web-based playground for exploring **Temporal AI Cookbook** patterns. Users can run AI workflows with different LLM providers (OpenAI, Anthropic, Groq, Ollama), visualize execution in real-time, and learn Temporal patterns through hands-on experimentation.

**Key Differentiator**: Multi-provider LLM support in a single UI - swap between OpenAI, Anthropic, Groq, and local Ollama models without code changes.

## Development Approach

### Incremental Vertical Slices
Build one complete AI pattern at a time, from frontend to Temporal integration:
- Each slice includes: Python worker + Phoenix UI + Temporal client + visualization
- Start with LiteLLM pattern (simplest, multi-provider foundation)
- Validate architecture early with first slice before scaling

### UI Mockup First
Low-fidelity wireframes establish visual direction before implementation:
- Sketch main pages: catalog, pattern detail, execution view
- Define layout and component structure
- Iterate quickly on paper/digital wireframes

### Feature-Based Workflow
- **GitHub Issues**: Each feature = one GitHub issue
- **Detailed PRDs**: `/docs/features/feature-XXX-name.md` contains full specification
- **Task Lists**: `/docs/tasks/tasks-XXX.md` contains implementation checklist
- **This Plan**: High-level roadmap only, details live in feature PRDs

## MVP Features (7 features)

### Feature 1: UI Mockup & Foundation ✅ COMPLETE
**GitHub Issue**: #1 | **Priority**: High | **Estimate**: 2 days
**PRD**: `docs/features/feature-001-ui-mockup.md`

Create low-fidelity wireframes and Phoenix LiveView foundation.

**Key Deliverables**:
- Wireframe sketches: catalog page, pattern detail page, execution visualization
- Phoenix LiveView project initialized
- Basic routing structure (home, pattern detail)
- Base layout with navigation

**Exit Criteria**: Wireframes approved, Phoenix app runs, basic navigation functional

---

### Feature 2: LiteLLM Pattern - Complete Vertical Slice
**GitHub Issue**: #2 | **Priority**: High | **Estimate**: 5 days
**PRD**: `docs/features/feature-002-litellm-pattern.md`

First complete pattern implementation - LiteLLM with multi-provider support.

**Key Deliverables**:
- Python worker implementing LiteLLM pattern (from Temporal AI Cookbook)
- Phoenix UI: pattern detail page, prompt input form, model selector
- Temporal client integration: start workflow, retrieve history, display events
- Real-time visualization: timeline showing LLM activity execution
- Multi-provider support: OpenAI, Anthropic, Groq, local Ollama
- Interactive controls: model dropdown, prompt textarea, temperature/max_tokens sliders

**Exit Criteria**: User can run LiteLLM workflow with any provider, see real-time execution, view LLM responses

---

### Feature 3: Pattern Catalog & Navigation
**GitHub Issue**: #3 | **Priority**: High | **Estimate**: 2 days
**PRD**: `docs/features/feature-003-pattern-catalog.md`

Homepage displaying Temporal AI Cookbook pattern catalog.

**Key Deliverables**:
- Pattern catalog page with grid layout
- 7 AI Cookbook pattern cards: Hello World, LiteLLM, Structured Outputs, Retry Policy, Tool Calling Agent, Durable Agent, Deep Research
- Pattern metadata: description, tags, complexity level
- Navigation to pattern detail pages

**Exit Criteria**: Catalog displays all patterns, clicking card navigates to detail, LiteLLM pattern fully integrated

---

### Feature 4: Second Pattern Slice
**GitHub Issue**: #4 | **Priority**: Medium | **Estimate**: 3-4 days
**PRD**: `docs/features/feature-004-second-pattern.md`

Implement second AI pattern to validate component reusability.

**Candidates**: Tool Calling Agent OR Structured Outputs
**Key Deliverables**:
- Python worker for chosen pattern
- Pattern-specific UI controls (tool selector for agent, schema input for structured outputs)
- Reuse visualization components from Feature 2
- Pattern documentation

**Exit Criteria**: Two complete patterns working, shared components validated, architecture scales

---

### Feature 5: Worker Process Management
**GitHub Issue**: #5 | **Priority**: High | **Estimate**: 2 days
**PRD**: `docs/features/feature-005-worker-management.md`

Reliable Python worker supervision and health monitoring.

**Key Deliverables**:
- OTP supervision tree for Python worker processes
- Worker auto-start when Phoenix starts
- Worker auto-restart on failure
- Health check mechanism (heartbeat or task queue polling)
- UI status indicator: worker online/offline badge

**Exit Criteria**: Workers start automatically, restart on crash, health status visible in navbar

---

### Feature 6: Development Environment Setup
**GitHub Issue**: #6 | **Priority**: High | **Estimate**: 1.5 days
**PRD**: `docs/features/feature-006-dev-setup.md`

Local development environment and comprehensive setup documentation.

**Key Deliverables**:
- Temporal Dev Server installation guide (macOS, Linux, Windows)
- Environment variable configuration (.env template for API keys)
- README with step-by-step setup instructions
- Health check scripts (verify Temporal server, workers running)
- Troubleshooting guide for common setup issues

**Exit Criteria**: External developer can clone repo and run application following README

---

### Feature 7: Error Handling & Retry Visualization
**GitHub Issue**: #7 | **Priority**: Medium | **Estimate**: 2 days
**PRD**: `docs/features/feature-007-error-handling.md`

Visualize retry behavior and graceful error handling.

**Key Deliverables**:
- Display retry attempts in timeline (multiple activity executions)
- Error messages from LLM failures (auth errors, rate limits, timeouts)
- "Inject Failure" button to test retry behavior
- Graceful degradation: show partial results on transient failures
- Clear error recovery suggestions in UI

**Exit Criteria**: Retry attempts visible in timeline, errors handled gracefully, users understand Temporal retry patterns

---

## Implementation Sequence

1. **Week 1**: Feature 1 (Mockup) → Feature 6 (Setup Guide)
2. **Week 2-3**: Feature 2 (LiteLLM Pattern - vertical slice)
3. **Week 4**: Feature 3 (Catalog) → Feature 5 (Worker Management)
4. **Week 5-6**: Feature 4 (Second Pattern)
5. **Week 7**: Feature 7 (Error Handling) → MVP Demo

## Success Metrics

### MVP Completion Criteria
- [ ] 2+ AI Cookbook patterns working end-to-end
- [ ] Multi-provider LLM support (OpenAI, Anthropic, Groq, Ollama)
- [ ] Real-time workflow visualization functional
- [ ] External developer can set up and run locally
- [ ] Error handling and retry visualization working

### Technical Learning Goals
- Phoenix LiveView real-time patterns
- Temporal Python SDK integration
- LiteLLM multi-provider orchestration
- OTP worker supervision

## Risk Mitigation

### Risk 1: LLM Provider API Key Management
**Impact**: High | **Probability**: Medium
**Risk**: Users may not have API keys for all providers
**Mitigation**:
- Support local Ollama (no API key required)
- Provide clear setup guide for getting API keys
- Graceful handling when provider credentials missing

### Risk 2: Worker Process Complexity
**Impact**: Medium | **Probability**: Medium
**Risk**: Python worker supervision from Elixir may be fragile
**Mitigation**:
- Start with simple `System.cmd` approach
- Document manual worker startup as fallback
- Consider Docker Compose for production deployment

### Risk 3: LiteLLM Provider Compatibility
**Impact**: Low | **Probability**: Low
**Risk**: LiteLLM behavior varies across providers
**Mitigation**:
- Test with 3-4 major providers during Feature 2
- Document known provider differences
- Provide fallback suggestions in UI

## Next Steps

### Completed
1. [x] Create high-level feature plan (this document)
2. [x] Update PRD to reflect AI Cookbook focus
3. [x] Create Feature 1 PRD with wireframe sketches
4. [x] Create GitHub milestone "MVP Features"
5. [x] Create GitHub issues #1-#7
6. [x] Feature 1: Phoenix project initialized, 3 LiveView modules, navigation working

### Next Session
1. [ ] Start Feature 2: LiteLLM Pattern implementation
2. [ ] Create Feature 2 PRD
3. [ ] Set up Temporal client integration

---

**Plan Version**: 2.0 (AI Cookbook Focus)
**Previous Version**: 1.0 (General Temporal Cookbook - deprecated)
**Next Review**: After Feature 2 completion (end of Week 3)
