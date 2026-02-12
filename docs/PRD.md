# Temporal AI Cookbook UI - PRD

> **Original PRD Reference**: `/Users/joeszodfridt/src/brand/project-ideas/PRD_Temporal_Cookbook_UI.md`
>
> **Project Focus Update (2025-11-18)**: Pivoted from general Temporal Cookbook to **Temporal AI Cookbook** patterns with multi-provider LLM support.

## 1. Product Overview & Problem Statement

### Problem
Developers building AI applications with Temporal face unique challenges: orchestrating LLM calls, handling API failures and retries, managing expensive external operations, and ensuring durable AI workflows. The **Temporal AI Cookbook** provides code examples, but developers learn best through interactive experimentation. Current resources lack:
- **Interactive LLM workflow execution** with real providers (OpenAI, Anthropic, Groq, Ollama)
- **Visual representation** of AI workflow patterns (retry behavior, token usage, multi-step agents)
- **Multi-provider flexibility** to understand Temporal's value across different LLM APIs

### Solution
A web-based interactive playground for **Temporal AI Cookbook** patterns. Users can:
- Run AI workflows with their choice of LLM provider (OpenAI, Anthropic, Groq, local Ollama)
- Visualize execution history showing LLM activity retries, token usage, and timing
- Experiment with prompt engineering, model selection, and error handling
- Learn Temporal AI patterns through hands-on interaction without writing code

This educational tool bridges the gap between AI Cookbook documentation and production AI workflow development.

### Primary Goals
- **AI Workflow Education**: Demonstrate Temporal patterns for reliable AI orchestration (LiteLLM, tool calling agents, structured outputs, retries)
- **Multi-Provider Flexibility**: Enable switching between OpenAI, Anthropic, Groq, and Ollama to show Temporal's provider-agnostic value
- **Developer Experience**: Interactive UI for exploring AI workflows without environment setup or coding

### Scope
- **In Scope**:
  - Interactive catalog of **Temporal AI Cookbook** patterns (LiteLLM, Tool Calling, Structured Outputs, etc.)
  - Multi-provider LLM support: OpenAI, Anthropic, Groq, local Ollama
  - Real-time AI workflow visualization (LLM calls, retries, token usage, timing)
  - Ability to trigger workflows with custom prompts, model selection, and parameters
  - Support for Python worker examples (primary AI SDK language)
  - Educational focus with explanations of AI workflow patterns

- **Out of Scope**:
  - Production AI workflow deployment or monitoring
  - Custom workflow authoring or code editing in UI
  - Enterprise features like multi-cluster support or access control
  - Fine-tuning or model training capabilities
  - Cost optimization beyond visualization

---

## 2. Target Users & Use Cases

### Primary User
- **Developer Category**: AI/ML engineers and backend developers building LLM-powered applications
- **Role**: Developers evaluating Temporal for AI workflows, learning reliable LLM orchestration patterns, or building production AI systems
- **Context**: Learning environment, AI application prototyping, evaluating multi-provider strategies

### Use Cases & User Stories

#### Learning AI Workflow Patterns
- **Purpose**: Understand how to build reliable, durable AI workflows with Temporal
- **Key Needs**:
  - Run LLM workflows with real providers (OpenAI, Anthropic, Groq, Ollama)
  - See retry behavior when LLM API calls fail or rate-limit
  - Visualize token usage, latency, and cost implications
  - Experiment with different prompts and models interactively
- **Success Scenario**: An AI developer new to Temporal can run the LiteLLM pattern with 3 different providers in 15 minutes, understanding how Temporal handles retries and provides durability for expensive LLM calls

#### Multi-Provider Evaluation
- **Purpose**: Compare LLM providers and understand Temporal's provider-agnostic orchestration
- **Key Needs**:
  - Switch between OpenAI, Anthropic, Groq, Ollama without code changes
  - See execution differences (latency, token usage, costs)
  - Test fallback strategies when primary provider fails
- **Success Scenario**: A solutions architect can demonstrate to stakeholders how Temporal enables provider flexibility, running the same workflow across 4 providers and showing retry behavior during a live demo

#### Building Production AI Systems
- **Purpose**: Prototype and validate AI workflow patterns before production implementation
- **Key Needs**:
  - Understand tool-calling agent patterns
  - See structured output extraction in action
  - Validate retry policies for LLM-specific errors (rate limits, timeouts, auth)
- **Success Scenario**: An engineer building a multi-step AI agent can explore the Tool Calling Agent pattern, understand execution flow, and adapt the pattern to their production use case

### Success Scenarios
- Developer runs LiteLLM workflow with Ollama (local, no API key), then switches to Anthropic, seeing identical workflow behavior
- User injects rate-limit failure, observes Temporal's automatic retry with exponential backoff
- Solutions architect demonstrates tool-calling agent executing multi-step research task with real-time visualization
- Developer compares token usage across OpenAI GPT-4 vs Anthropic Claude vs Groq Mixtral for cost analysis

## 3. Core Features & Functionality

### Core Processing Features

#### Workflow Catalog & Browsing
- **Pattern Categories**: Organize examples by pattern type (Cron/Scheduling, Signals & Queries, Child Workflows, Error Handling, Versioning)
- **Pattern Metadata**: Display description, use cases, complexity level, and supported SDKs for each pattern
- **Quick Start**: One-click workflow launch with sensible default parameters

#### Workflow Execution & Control
- **Launch Workflows**: User-friendly forms for providing workflow input parameters
- **Send Signals**: Interactive controls to send signals to running workflows
- **Inject Failures**: Controlled failure injection to demonstrate retry and compensation logic
- **Query Workflow State**: Real-time queries to inspect workflow state and variables

#### Visualization & Monitoring
- **Execution Timeline**: Visual representation of workflow events over time
- **Event History**: Detailed view of Temporal event history with event types and payloads
- **State Visualization**: Display current workflow state, pending activities, and timers
- **Real-time Updates**: LiveView-based real-time updates as workflow executes

### Feature-Specific Requirements

#### Workflow Execution Timeline Visualization
- Display workflow events chronologically using Mermaid.js sequence diagrams or interactive timeline
- Show activity executions, retries, timer fires, signal received events
- Color-code events by type (activity started/completed, workflow started/completed, failures, signals)
- Support zoom/pan for long-running workflows with many events
- Provide event detail popover on hover/click

#### Multi-Language SDK Support
- Run identical workflow patterns in both Python and Go workers
- Allow user to select SDK language for each pattern execution
- Display language-specific code snippets alongside visualization
- Demonstrate cross-language consistency of Temporal orchestration

### Additional Features
- **Pattern Comparison**: Side-by-side comparison of similar patterns (e.g., retry strategies)
- **Code Examples**: Display relevant Cookbook code snippets for reference
- **Export History**: Download workflow history as JSON for offline analysis

## 4. Security & Privacy

### Data Processing Philosophy
- **Local Development**: Designed for local or educational environments, not production workloads
- **Ephemeral Data**: Workflow executions are temporary demonstrations, not persistent production data
- **No PII**: Example workflows use synthetic data only, no real user or business information

### Data Handling

#### Workflow Data Processing
- **Input Sanitization**: Validate and sanitize all user-provided workflow inputs to prevent injection attacks
- **Output Display**: Safely render workflow outputs and event payloads in UI without XSS vulnerabilities
- **History Access**: Limit history retrieval to workflows launched through the UI (prevent unauthorized access to external workflows)

#### File/Data Lifecycle Management
- **Temporary Storage**: Workflow results stored in browser session only, cleared on page refresh
- **No Persistence**: No database or long-term storage of workflow data
- **Clean Shutdown**: Graceful cleanup of running workflows on application shutdown

### Security Configuration

#### Temporal Server Access
- **Local Dev Server**: Primary use case assumes local Temporal Dev Server on localhost
- **Access Control**: Support Temporal server mTLS and authentication for secure deployments
- **Namespace Isolation**: Use dedicated namespace for cookbook examples (e.g., `cookbook-ui`)

### Privacy Considerations

#### User Data
- **No User Tracking**: No analytics, telemetry, or user behavior tracking
- **No Authentication**: Designed as open educational tool, no user accounts or login
- **Local Execution**: All processing happens locally, no data sent to external services

### Compliance
- **Educational Use**: Designed for learning and demonstration, not subject to production compliance requirements
- **Open Source**: MIT license, code transparency for security review
- **Safe Defaults**: Secure default configurations, documented security considerations for deployment

---

## 5. Technical Requirements

### Core Technology Stack

#### Frontend
- **Elixir + Phoenix LiveView**: Real-time, reactive UI with server-side rendering for workflow visualization
- **Mermaid.js**: Declarative diagram generation for workflow event timelines
- **Tailwind CSS**: Utility-first styling for responsive, modern UI design

#### Backend Workers
- **Python Workers**: Single shared worker process registering all 7 cookbook workflows (Temporal-standard pattern - see ADR 001)
- **Go Workers**: (Future) Temporal workers implementing Cookbook examples from Go SDK
- **Temporal SDK Clients**: Elixir/Phoenix integration with Temporal gRPC API for workflow control

#### Infrastructure
- **Temporal Dev Server**: Local Temporal server for workflow orchestration
- **Phoenix Server**: Web server hosting LiveView application
- **Worker Process**: Single Python worker process (workers are infrastructure, not app-controlled - see ADR 001)

### System Architecture

#### Frontend Layer
- **LiveView Components**: Real-time UI components for workflow state, history, and controls
- **WebSocket Connection**: Persistent connection for real-time updates from Temporal
- **Client-Side Rendering**: Mermaid.js rendering of workflow diagrams in browser

#### Backend Layer
- **Phoenix Controllers**: API endpoints for workflow launch, signals, queries
- **Temporal Client**: Elixir Temporal SDK client for workflow operations
- **Worker Status Monitor**: Health check mechanism for worker availability (workers are infrastructure, not managed by Phoenix - see ADR 001)

#### Workflow Layer
- **Python Worker**: Single Python process registering all 7 cookbook workflows (shared worker pattern - see ADR 001)
- **Go Workers**: (Future) Compiled Go binaries running Temporal workers with Cookbook workflow implementations
- **Temporal Server**: Local Temporal Dev Server handling workflow orchestration

### Technical Constraints

#### Performance Requirements
- **Workflow Launch Latency**: < 500ms from user click to workflow started confirmation
- **Visualization Rendering**: < 1s to render workflow history visualization for typical workflows (< 100 events)
- **Real-time Updates**: < 200ms delay for workflow state updates in UI

#### Integration Requirements
- **Temporal gRPC API**: Integration with Temporal frontend service via gRPC
- **Worker Communication**: Workers register with Temporal server on configured task queues
- **Event Streaming**: Phoenix LiveView subscribes to workflow events for real-time updates

#### Deployment Considerations
- **Local Development**: Primary deployment is localhost for individual developers
- **Docker Compose**: Optionally provide Docker Compose setup for one-command startup
- **Port Configuration**: Configurable ports for Phoenix (default 4000), Temporal (default 7233)

### Error Handling & Recovery

#### Temporal Connection Errors
- **Server Unavailable**: Display clear error message if Temporal Dev Server not running, with setup instructions
- **Worker Not Running**: Detect if worker not available, provide guidance to start worker manually (workers are infrastructure - see ADR 001)
- **Network Timeout**: Handle gRPC timeouts gracefully, allow user to retry operation

#### Error Recovery UX
- **Graceful Degradation**: Show partial workflow history if real-time updates fail
- **Clear Error Messages**: User-friendly error descriptions with actionable next steps
- **Retry Mechanisms**: Automatic retry for transient failures, manual retry button for user-initiated actions

## 6. User Experience & Workflow

### Design Philosophy
- **Education First**: Prioritize clarity and learning over feature density
- **Visual Feedback**: Rich visual representation of workflow execution and state
- **Minimal Friction**: One-click workflow launch with sensible defaults, optional parameter customization

### Core User Journey

#### Primary Workflow
1. **Browse Catalog**: User lands on homepage, sees grid of workflow pattern cards with descriptions
2. **Select Pattern**: User clicks on pattern card (e.g., "Cron Scheduling"), navigates to pattern detail page
3. **Review Pattern Info**: Page displays pattern description, use cases, code snippet, and input form
4. **Launch Workflow**: User optionally customizes input parameters, clicks "Run Workflow" button
5. **Observe Execution**: Real-time visualization shows workflow events as they occur, user can send signals or inject failures
6. **Inspect History**: User explores detailed event history, examines payloads, understands workflow behavior

#### Page Flow
```
Home (Pattern Catalog)
├── Pattern Grid (card layout with pattern categories)
├── Quick Filter (by category, language, complexity)
└── Pattern Detail Page (selected pattern)
    ├── Pattern Overview (description, use case, diagram)
    ├── Code Example (collapsible code snippet from Cookbook)
    ├── Launch Controls (input form, Run button, language selector)
    └── Execution Visualization (timeline, history, state inspector)
        ├── Timeline View (Mermaid.js diagram of events)
        ├── Event History (scrollable list of Temporal events)
        ├── Interactive Controls (Send Signal, Inject Failure buttons)
        └── State Inspector (current workflow variables, pending activities)
```

### User Interface Requirements

#### Pattern Catalog Page
- **Visual Hierarchy**: Clear categorization of patterns with icons for pattern types
- **Searchable**: Filter patterns by name, category, or SDK language
- **Information Scent**: Each card shows complexity level (Easy/Medium/Hard) and estimated run time

#### Pattern Execution Page
- **Split Layout**: Code/description on left, visualization on right (desktop), stacked on mobile
- **Responsive Controls**: Workflow controls always accessible, sticky header with workflow ID and status
- **Progressive Disclosure**: Advanced parameters collapsed by default, expandable for power users

### Interaction Patterns

#### Workflow Execution States
- **Idle**: Pattern detail shown, "Run Workflow" button enabled
- **Running**: Visualization updating in real-time, controls enabled (Send Signal, Inject Failure)
- **Completed**: Final state shown, "Run Again" button replaces "Run Workflow"
- **Failed**: Error state highlighted, failure reason displayed, retry option available

#### Real-time Updates
- **Optimistic UI**: Immediate visual feedback when user clicks Run/Signal/Fail
- **Server Push**: LiveView pushes new events from Temporal to browser automatically
- **Animation**: Smooth transitions as new events appear in timeline

### Responsive Design
- **Desktop**: Side-by-side code and visualization, full event details visible
- **Tablet**: Stacked layout with tabs (Code | Visualization), condensed event list
- **Mobile**: Single-column layout, simplified timeline, essential information only

## 7. Success Metrics

### MVP Success Criteria

#### Primary Success Metrics
- **Pattern Coverage**: At least 8-10 core Temporal patterns implemented and visualizable (Cron, Child Workflows, Signals, Queries, Retries, Compensation, Versioning)
- **Execution Reliability**: 95%+ workflow launch success rate (workflows start and complete as expected)
- **Visualization Quality**: All workflow events visible in timeline within 1 second of occurrence

#### Quality Validation
- **Manual Testing**: Each pattern verified with multiple input variations, edge cases tested
- **Visual Regression**: Timeline and UI components render correctly across browsers (Chrome, Firefox, Safari)
- **Cross-Language Parity**: Identical patterns produce equivalent visualizations in Python and Go

#### Performance Benchmarks
- **Page Load**: Pattern catalog loads in < 2s on typical broadband connection
- **Workflow Start**: Workflow begins executing within 500ms of user clicking Run
- **History Rendering**: 50-event workflow history renders in < 1s

### Technical Learning Goals & Knowledge Development

#### Phoenix LiveView Mastery
- **Real-time State Management**: Master LiveView lifecycle, handle_event, handle_info patterns
  - Success Criteria: Implement bidirectional real-time updates for workflow state without manual WebSocket code
  - Evidence: Clean, maintainable LiveView modules with clear separation of concerns
  - Learning Timeline: Week 1-2 of development
  - Practical Application: Real-time workflow visualization and event streaming

- **Component Architecture**: Build reusable LiveView components for workflow UI elements
  - Success Criteria: Create 5+ reusable LiveComponents (PatternCard, EventTimeline, WorkflowControls, etc.)
  - Evidence: Components used across multiple patterns without duplication
  - Learning Timeline: Throughout MVP phase
  - Practical Application: Consistent UI across all workflow patterns

#### Temporal Multi-Language Integration Development
- **SDK Client Integration**: Integrate Temporal gRPC client from Elixir, orchestrate workflows from Phoenix
  - Success Criteria: Successfully start workflows, send signals, and query state from Phoenix backend
  - Evidence: Working Temporal client library integration with error handling
  - Learning Timeline: Week 1-2 of development
  - Practical Application: All workflow control operations (launch, signal, query, terminate)

- **Worker Process Management**: Monitor worker health and understand worker architecture (workers are infrastructure, not app-controlled - see ADR 001)
  - Success Criteria: Health checks confirm worker availability, UI shows worker status, manual worker control documented
  - Evidence: Worker status monitoring, health check mechanism, clear documentation
  - Learning Timeline: Week 2-3 of development (Feature 2)
  - Practical Application: Understanding production-realistic Temporal worker patterns

### Learning Progress Integration
- **Learning Reviews**: Scheduled every 2 weeks alongside sprint reviews
- **Knowledge Capture**: Document insights in `docs/decisions/` (e.g., "Why LiveView for visualization", "Shared worker architecture" - see ADR 001)
- **Skill Application**: Each learning goal must be applied in actual project features (e.g., LiveView components used for all visualizations)
- **Progress Metrics**: Track learning completion alongside feature development metrics (e.g., "Mastered LiveView components: 5/5")

### Testing Strategy Evolution

#### Phase 1 Testing (MVP)
- **Initial Coverage Target**: 40% code coverage
- **Test Types**:
  - Unit tests for Phoenix controllers and Temporal client wrapper
  - Integration tests for workflow launch and signal sending
  - Basic LiveView component testing (render tests)
- **Testing Framework**: ExUnit for Elixir, pytest for Python workers, Go testing for Go workers
- **Success Criteria**: All core workflow operations (launch, signal, query) have passing tests

#### Phase 2 Testing (Enhanced)
- **Enhanced Coverage Target**: 65% code coverage
- **Additional Test Types**:
  - End-to-end testing with Wallaby (Phoenix E2E framework)
  - Performance/load testing for concurrent workflow launches
  - Visual regression testing for timeline rendering (Percy or similar)
- **Test Automation**: CI/CD integration with GitHub Actions for automated test runs
- **Quality Gates**: Tests must pass before PR approval

#### Phase 3 Testing (Production-Ready)
- **Production Coverage Target**: 80% code coverage
- **Advanced Test Types**:
  - Property-based testing for workflow input validation (StreamData)
  - Chaos engineering for worker failure scenarios
  - User acceptance testing with real developer workflows (beta testers)
- **Monitoring Integration**: Test result integration with monitoring dashboard
- **Regression Prevention**: Comprehensive test suite prevents future bugs in workflow patterns

### Testing Milestone Progression
- **Testing Milestone 1** (End of Week 3): Basic test suite operational, core operations tested
- **Testing Milestone 2** (End of Week 6): Enhanced coverage with E2E tests, CI/CD pipeline active
- **Testing Milestone 3** (End of Week 10): Production-ready test infrastructure with property-based and chaos tests

### Extensibility Framework Success

#### Pattern Extensibility
- **New Pattern Addition**: Adding a new Cookbook pattern requires < 2 hours (workflow code + UI config)
- **SDK Addition**: Framework supports adding new SDK languages (e.g., TypeScript, Java) without core refactoring
- **Custom Visualizations**: Pattern-specific visualizations can be added via pluggable renderer system

#### Integration Extensibility
- **Temporal Cloud Support**: UI can connect to Temporal Cloud namespaces with configuration change (no code changes)
- **Advanced Features**: Support for Temporal advanced features (schedules, updates, async activity completion) can be added incrementally
- **Export Formats**: Additional export formats (PDF reports, screenshots) can be added via plugin architecture

### Acceptance Criteria

#### MVP Launch Criteria
- [ ] At least 8 core workflow patterns implemented and visualizable
- [ ] Python worker operational (single shared worker registering all patterns - see ADR 001)
- [ ] Real-time workflow execution visualization working reliably
- [ ] Users can launch workflows, send signals, and inject failures through UI
- [ ] Comprehensive README with setup instructions and architecture overview

#### Technical Foundation Criteria
- [ ] Phoenix LiveView application running stably with WebSocket connections
- [ ] Temporal client integration functional (start workflow, signal, query, get history)
- [ ] Worker health monitoring implemented (workers are infrastructure, not supervised by Phoenix - see ADR 001)
- [ ] Basic test coverage (40%+) with passing CI pipeline
- [ ] Error handling for common failure scenarios (server down, worker unavailable, timeout)

#### Future-Ready Criteria
- [ ] Modular architecture supports adding new patterns without refactoring
- [ ] Configuration-based pattern definition (minimize code for new patterns)
- [ ] Documentation structure supports community contributions
- [ ] Extensibility hooks for custom visualizations and advanced features

## 8. Implementation Phases & Project Lifecycle

### Development Philosophy
- **Incremental Delivery**: Ship working patterns incrementally rather than waiting for all patterns
- **Learning-Driven**: Prioritize deep understanding of Temporal and Phoenix over speed
- **Visual First**: Focus on visualization quality as differentiator

### Project Lifecycle Stages

#### Stage 0: Planning & Requirements (Pre-Development)
**Duration**: 1 week
**Key Activities**:
- [x] PRD completion and review
- [ ] Technology stack research (Phoenix LiveView, Temporal Elixir client options)
- [ ] Development environment setup (Elixir, Phoenix, Temporal Dev Server, Go, Python)
- [ ] GitHub repository and workflow configuration
- [ ] Initial architecture decisions documented (shared worker architecture - ADR 001, visualization approach)

**Exit Criteria**:
- PRD approved and baselined
- Development environment functional (Phoenix app runs, Temporal server accessible)
- First GitHub milestone created with issues for MVP patterns
- Architecture foundation decisions made (documented in `docs/decisions/`)

#### Stage 1: MVP Foundation (Core Development)
**Duration**: 4-6 weeks
**Key Activities**:
- [ ] Phoenix LiveView application structure and routing
- [ ] Temporal client integration (Elixir wrapper for Temporal gRPC)
- [ ] First 3 workflow patterns implemented (Cron, Signal, Retry)
- [ ] Basic timeline visualization (Mermaid.js integration)
- [ ] Worker health monitoring (workers are infrastructure - see ADR 001)
- [ ] Basic testing framework establishment

**Exit Criteria**:
- Core user journey works end-to-end (browse → select → launch → visualize)
- At least 3 workflow patterns fully functional with visualization
- Basic test coverage achieved (40%)
- Application deployable to local development environment
- MVP acceptance criteria met

#### Stage 2: Feature Enhancement (Growth)
**Duration**: 3-4 weeks
**Key Activities**:
- [ ] Additional 5-7 workflow patterns (Child Workflows, Versioning, Compensation, Queries, etc.)
- [ ] Enhanced visualization (timeline zoom, event filtering, state inspector)
- [ ] Performance optimization (lazy loading, event pagination)
- [ ] Extended test coverage (E2E tests, visual regression)
- [ ] Documentation completion (architecture docs, contribution guide)

**Exit Criteria**:
- All planned workflow patterns (8-10) operational
- Enhanced visualization features complete
- Improved test coverage (65%)
- Performance benchmarks met (< 500ms workflow launch, < 1s history render)
- Production-ready documentation

#### Stage 3: Production Readiness (Hardening)
**Duration**: 2-3 weeks
**Key Activities**:
- [ ] Security review (input sanitization, XSS prevention, Temporal access control)
- [ ] Reliability improvements (connection retry, graceful shutdown, worker health monitoring)
- [ ] Monitoring and observability (structured logging, health checks, metrics)
- [ ] Docker Compose deployment setup
- [ ] User acceptance testing with beta users (Temporal community developers)

**Exit Criteria**:
- Security requirements satisfied (safe input handling, secure Temporal connection)
- Docker Compose setup allows one-command startup
- Monitoring and health checks operational
- Beta user feedback incorporated

#### Stage 4: Maintenance & Evolution (Post-Launch)
**Duration**: Ongoing
**Key Activities**:
- [ ] Bug fixes and stability improvements based on user reports
- [ ] New Cookbook patterns added as Temporal releases them
- [ ] Temporal SDK version updates
- [ ] Community feature requests and contributions
- [ ] Advanced features (Temporal Cloud support, custom visualizations, export formats)

**Success Metrics**:
- GitHub issues response time < 7 days
- New Cookbook patterns added within 1 month of official release
- Community contributions successfully merged
- Temporal SDK updates incorporated quarterly

### Phase 1: MVP Core Patterns (Weeks 1-6)
**Goal**: Deliver functional interactive playground for 3 core Temporal patterns

#### Development Approach
Start with simplest patterns to validate architecture, then add complexity. Focus on end-to-end flow (UI → Phoenix → Temporal → Worker → Visualization) for first pattern, then replicate for additional patterns.

#### Phase 1 Development Items
1. **Week 1-2: Foundation**
   - Phoenix LiveView project setup
   - Temporal Dev Server integration and client wrapper
   - Pattern catalog homepage (static list)
   - First pattern: Cron Workflow (simple, predictable events)

2. **Week 3-4: Core Visualization**
   - Mermaid.js timeline rendering
   - Event history retrieval and display
   - Real-time updates via LiveView
   - Second pattern: Signal Workflow (introduces user interaction)

3. **Week 5-6: Multi-Language & Testing**
   - Worker health monitoring (shared worker architecture - see ADR 001)
   - Language selector UI
   - Third pattern: Retry Workflow (demonstrates error handling)
   - Basic test suite (unit + integration)

#### Technical Focus
- Phoenix LiveView real-time capabilities
- Temporal gRPC client integration from Elixir
- Worker health monitoring (workers are infrastructure - see ADR 001)

#### Success Criteria
- 3 patterns working end-to-end with real-time visualization
- Python worker operational (shared worker pattern - see ADR 001)
- Users can interact with workflows (send signals)
- Basic tests passing

### Phase 2: Expanded Pattern Library (Weeks 7-10)
**Goal**: Complete pattern catalog with 8-10 patterns, enhanced visualization

#### Scope
- **Pattern Expansion**: Add Child Workflows, Versioning, Compensation, Queries, Activity Heartbeats
- **Visualization Enhancement**: Timeline zoom/pan, event filtering, state variable display
- **UX Polish**: Pattern search/filter, improved parameter forms, error messaging

#### Technical Focus
- Performance optimization (event pagination for long histories)
- Advanced LiveView component patterns
- Visual design refinement

#### Success Criteria
- 8-10 patterns fully functional
- Enhanced visualization features complete
- Positive user feedback on UX
- E2E test coverage for critical paths

### Phase 3: Production Hardening (Weeks 11-13)
**Goal**: Security, reliability, and deployment readiness

#### Scope
- **Security**: Input validation, XSS prevention, Temporal connection security (mTLS)
- **Reliability**: Worker health monitoring, connection retry logic, graceful degradation
- **Deployment**: Docker Compose setup, environment configuration, setup documentation

#### Technical Focus
- Security best practices (OWASP Top 10 review)
- OTP supervision tree optimization
- Docker multi-stage builds for Go/Python workers

#### Success Criteria
- Security review passed (no critical vulnerabilities)
- Docker Compose one-command startup working
- Health checks and monitoring operational
- Beta user acceptance testing complete

### Phase 4: Community & Advanced Features (Future)
**Goal**: Community engagement, advanced Temporal features, extensibility

#### Potential Scope
- **Community**: Contribution guide, issue templates, pattern submission process
- **Advanced Features**: Temporal Cloud support, Schedules API, Async Activity Completion, Updates
- **Extensibility**: Plugin system for custom visualizations, export to various formats

### Risk Mitigation Strategy

#### MVP Phase Risks
- **Temporal Elixir Client Maturity**: Temporal Elixir SDK may lack features vs Go/Python SDKs
  - Mitigation: Use gRPC client directly, contribute missing features to Elixir SDK community project
- **LiveView Performance**: Real-time updates for long workflow histories may cause performance issues
  - Mitigation: Implement event pagination, lazy loading, and virtual scrolling for large histories
- **Worker Complexity**: Managing worker processes from Elixir may be fragile
  - Mitigation: **Architecture Decision**: Workers are infrastructure, not app-controlled (ADR 001). Primary approach: Manual terminal control. Optional OTP supervision for convenience (Feature 5). Provide clear worker health status in UI, document worker setup.

#### Technical Spikes (If Needed)
- **Temporal gRPC Client**: 2-day spike to evaluate Elixir Temporal client libraries (tortoise, temporalio/sdk-elixir)
- **Mermaid.js Limitations**: 1-day spike to validate Mermaid.js can handle complex workflow timelines, consider alternatives (D3.js)
- **Worker Architecture**: Decision made - shared worker pattern (ADR 001). Workers are infrastructure, not supervised by Phoenix. Optional OTP supervision for convenience.

### Definition of Done (Each Phase)
- [ ] All planned features implemented and manually tested
- [ ] Test coverage target met with passing CI build
- [ ] Documentation updated (README, architecture docs, code comments)
- [ ] No critical bugs or security vulnerabilities
- [ ] Peer code review completed
- [ ] Demo-ready (can present working features to stakeholders)

---

## Executive Summary

### Product Vision
Transform Temporal.io learning from static documentation to interactive, visual exploration. The Temporal Cookbook UI makes distributed workflow orchestration concepts accessible to developers through hands-on experimentation with real Temporal workflows, eliminating the barrier of environment setup and code writing.

### Key Success Factors
1. **Educational Impact**: Developers gain practical understanding of Temporal patterns in minutes, not hours
2. **Visualization Quality**: Real-time, accurate workflow execution timelines that clearly show Temporal's behavior
3. **Technical Foundation**: Robust Phoenix LiveView + Temporal integration that serves as reference for Elixir + Temporal projects
4. **Community Value**: Open-source tool that benefits Temporal ecosystem and demonstrates best practices

### Next Steps
1. **Environment Setup**: Install Elixir, Phoenix, Temporal Dev Server, configure development environment
2. **Architecture Design**: Document detailed architecture decisions (shared worker architecture - ADR 001, client integration, visualization approach)
3. **First Pattern Implementation**: Build end-to-end flow for Cron Workflow pattern (simplest pattern to validate architecture)
4. **Iteration & Feedback**: Gather feedback from Temporal community, iterate on UX and technical approach

### Risk Mitigation
- Start with simplest patterns to validate architecture before adding complexity
- Use technical spikes to de-risk key integrations (Temporal client). Worker architecture decided (ADR 001).
- Engage Temporal community early for feedback on approach and value proposition
- Prioritize incremental delivery to get early validation of learning value
