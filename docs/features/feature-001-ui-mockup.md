# Feature 001: UI Mockup & Phoenix Foundation

**GitHub Issue**: #1
**Status**: Complete
**Priority**: High
**Estimate**: 2 days
**Owner**: @jszod
**Started**: 2025-11-21
**Completed**: 2025-11-24

## Overview

Create low-fidelity wireframe mockups for the Temporal AI Cookbook UI and initialize Phoenix LiveView foundation. This feature establishes the visual direction and technical foundation for the entire application.

## Problem Statement

Before building the UI, we need:
1. **Visual direction**: Wireframes defining layout, navigation, and component structure
2. **Technical foundation**: Phoenix LiveView project with routing and basic layout
3. **Team alignment**: Shared understanding of UI flow and user experience

## Goals

### Primary Goals
- Create low-fidelity wireframes for 3 core pages (catalog, pattern detail, execution view)
- Initialize Phoenix LiveView project with Tailwind CSS
- Establish basic routing structure
- Create base layout with navigation header

### Success Metrics
- Wireframes approved by stakeholders
- Phoenix server runs on localhost:4000
- Basic navigation between pages functional
- Foundation ready for Feature 2 (LiteLLM pattern) implementation

## User Stories

### As a developer exploring AI patterns
- I want to see a visual preview of the application structure
- So I can understand the user journey before implementation begins

### As an engineer building the UI
- I want a Phoenix LiveView project with routing configured
- So I can start implementing pattern pages immediately

## Wireframe Requirements

### Page 1: Pattern Catalog (Homepage)
**URL**: `/`

**Layout**:
```
┌─────────────────────────────────────────────────────┐
│ [Logo] Temporal AI Cookbook        [Worker: ●]     │ ← Header
├─────────────────────────────────────────────────────┤
│                                                     │
│   Explore Temporal AI Patterns                     │ ← Hero
│   Interactive playground for AI workflow learning  │
│                                                     │
├─────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ LiteLLM  │  │ Tool     │  │Structured│         │
│  │ Pattern  │  │ Calling  │  │ Outputs  │         │ ← Pattern Cards
│  │ [icon]   │  │ [icon]   │  │ [icon]   │         │   (3 columns)
│  │ Easy     │  │ Medium   │  │ Medium   │         │
│  └──────────┘  └──────────┘  └──────────┘         │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ Retry    │  │ Durable  │  │  Deep    │         │
│  │ Policy   │  │  Agent   │  │ Research │         │
│  │ [icon]   │  │ [icon]   │  │ [icon]   │         │
│  │ Easy     │  │ Hard     │  │ Hard     │         │
│  └──────────┘  └──────────┘  └──────────┘         │
└─────────────────────────────────────────────────────┘
```

**Components**:
- Header: Logo, worker status indicator (green dot = online)
- Hero section: Title and tagline
- Pattern grid: 6-7 cards in 3-column responsive grid
- Card content: Icon, title, complexity badge, short description

**Interactions**:
- Click card → navigate to pattern detail page
- Hover card → slight elevation/shadow effect

---

### Page 2: Pattern Detail Page
**URL**: `/patterns/litellm`

**Layout**:
```
┌─────────────────────────────────────────────────────┐
│ [Logo] Temporal AI Cookbook        [Worker: ●]     │ ← Header
├─────────────────────────────────────────────────────┤
│ ← Back to Catalog    LiteLLM Pattern               │ ← Breadcrumb
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─────────────────┐  ┌───────────────────────────┐ │
│ │ Pattern Info    │  │ Workflow Execution        │ │
│ │                 │  │                           │ │
│ │ What it does    │  │ [Model Selector ▼]       │ │ ← Split Layout
│ │ Learn about...  │  │ OpenAI | Anthropic       │ │   Left: Info
│ │                 │  │ Groq   | Ollama          │ │   Right: Controls
│ │ [Code Snippet]  │  │                           │ │
│ │ ▶ Show code     │  │ Prompt:                  │ │
│ │                 │  │ ┌───────────────────────┐ │ │
│ │                 │  │ │ [Text area for prompt]│ │ │
│ │                 │  │ └───────────────────────┘ │ │
│ │                 │  │                           │ │
│ │                 │  │ Temperature: [slider] 0.7│ │
│ │                 │  │ Max Tokens:  [input] 500 │ │
│ │                 │  │                           │ │
│ │                 │  │ [Run Workflow] button    │ │
│ └─────────────────┘  └───────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

**Components**:
- Breadcrumb navigation
- Left panel: Pattern description, use case, collapsible code snippet
- Right panel: Workflow controls (model selector, prompt input, parameters)
- Run Workflow button (primary CTA)

**Interactions**:
- Select provider from model dropdown
- Enter custom prompt in textarea
- Adjust temperature slider
- Click "Run Workflow" → navigate to execution view

---

### Page 3: Workflow Execution View
**URL**: `/patterns/litellm/executions/:workflow_id`

**⚠️ Feature 001 Scope**: Basic placeholder only. Full wireframe below shows future implementation (Features 2-7).

**Placeholder Implementation**:
- Route configured and working
- Shows workflow ID from URL
- "Coming soon" message with feature preview
- Back navigation to pattern detail page
- Link to Temporal UI for advanced users

**Full Implementation** (shown in wireframe below, implemented in Features 2-7):

**Layout**:
```
┌─────────────────────────────────────────────────────┐
│ [Logo] Temporal AI Cookbook        [Worker: ●]     │ ← Header
├─────────────────────────────────────────────────────┤
│ ← Back to Pattern    LiteLLM Execution             │ ← Breadcrumb
│ Workflow ID: abc-123-def    Status: [Running ⟳]   │ ← Status Bar
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─────────────────────────────────────────────────┐ │
│ │ Timeline Visualization (Mermaid.js)             │ │
│ │                                                 │ │
│ │ User ─────→ Workflow ─────→ LiteLLM Activity    │ │ ← Visual Timeline
│ │       Start          Execute   → OpenAI API    │ │
│ │                               ← Response        │ │
│ │                      Complete                   │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌──────────────────┐  ┌───────────────────────────┐ │
│ │ Event History    │  │ Workflow Result           │ │
│ │                  │  │                           │ │ ← Split: Events
│ │ ● WorkflowStart  │  │ LLM Response:             │ │   + Result
│ │   12:34:01       │  │ ┌───────────────────────┐ │ │
│ │                  │  │ │ [AI response text...] │ │ │
│ │ ● ActivityStart  │  │ └───────────────────────┘ │ │
│ │   12:34:02       │  │                           │ │
│ │   LLM call...    │  │ Tokens: 450              │ │
│ │                  │  │ Latency: 1.2s            │ │
│ │ ● ActivityDone   │  │ Cost: $0.002             │ │
│ │   12:34:03       │  │                           │ │
│ │   [expand ▼]     │  │ [Run Again] [Share]      │ │
│ └──────────────────┘  └───────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

**Components**:
- Status bar: Workflow ID, status badge (Running/Completed/Failed)
- Timeline visualization: Mermaid.js sequence diagram
- Event history: Scrollable list of Temporal events
- Result panel: LLM response, token count, latency, estimated cost
- Action buttons: Run Again, Share execution

**Interactions**:
- Real-time updates: Timeline and events update as workflow executes
- Expand event: Click event to see full payload
- Run Again: Re-run workflow with same parameters
- Share: Copy workflow execution URL

---

## Technical Implementation

### Phoenix LiveView Setup

#### Initialize Project
```bash
# Run from parent directory (/Users/joeszodfridt/src/temporal/)
cd /Users/joeszodfridt/src/temporal/temporal-cookbook-ui
mix phx.new . --app temporal_cookbook_ui --live --no-ecto
```

**Why `--no-ecto`**: We don't need a database for MVP - workflows stored in Temporal, no persistent UI data.

**Note**: The directory name uses hyphens (`temporal-cookbook-ui`) while the app name uses underscores (`temporal_cookbook_ui`). This follows Elixir conventions.

#### Configure Tailwind CSS

Add to `mix.exs`:
```elixir
{:tailwind, "~> 0.2", runtime: Mix.env() == :dev}
```

Run:
```bash
mix deps.get
mix tailwind.install
```

#### Routing Structure

`lib/temporal_cookbook_ui_web/router.ex`:
```elixir
scope "/", TemporalCookbookUiWeb do
  pipe_through :browser

  live "/", PatternCatalogLive
  live "/patterns/:pattern_id", PatternDetailLive
  live "/patterns/:pattern_id/executions/:workflow_id", ExecutionViewLive
end
```

#### Base Layout

Create `lib/temporal_cookbook_ui_web/components/layouts/root.html.heex`:
- Header with logo and worker status
- Main content area (LiveView renders here)
- Footer (optional for MVP)

### LiveView Modules (Placeholders)

#### `pattern_catalog_live.ex`
```elixir
defmodule TemporalCookbookUiWeb.PatternCatalogLive do
  use TemporalCookbookUiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, patterns: mock_patterns())}
  end

  defp mock_patterns() do
    [
      %{id: "litellm", name: "LiteLLM Pattern", complexity: "Easy"},
      # ... more patterns
    ]
  end
end
```

Similar placeholder structure for `PatternDetailLive` and `ExecutionViewLive`.

---

## Acceptance Criteria

### Wireframes
- [x] Catalog page wireframe created (digital or hand-drawn sketch)
- [x] Pattern detail page wireframe created
- [x] Execution view wireframe created
- [x] Wireframes reviewed and approved

### Phoenix Setup
- [x] Phoenix LiveView project initialized
- [x] Tailwind CSS configured and working
- [x] Three routes defined and accessible
- [x] Base layout with header renders correctly

### Navigation
- [x] Catalog page loads at `/`
- [x] Clicking pattern card navigates to `/patterns/litellm`
- [x] Pattern detail page displays placeholder content
- [x] Execution view loads at `/patterns/litellm/executions/test-123` (placeholder page)
- [x] Execution view shows workflow ID and "coming soon" message
- [x] Back navigation from execution view works

### Quality
- [x] Phoenix server runs without errors
- [x] No compilation warnings
- [x] Tailwind styles applied (basic header styling visible)
- [x] LiveView hot-reload working during development

---

## ExecutionViewLive Implementation Scope

### Feature 001 (Current)
**Goal**: Demonstrate routing and navigation structure

**Included**:
- Route configuration: `/patterns/:pattern_id/executions/:workflow_id`
- Basic LiveView module structure
- Placeholder UI with "coming soon" message
- Back navigation to pattern detail

**Excluded** (deferred to Features 2-7):
- Real-time workflow status updates
- Temporal SDK integration
- Event streaming and visualization
- Mermaid.js timeline diagrams
- "Run Again" and "Share" functionality
- Actual workflow data display

### Future Features (2-7)
**When to implement**: Once we have working Temporal workflows from pattern implementations

**Rationale**: ExecutionViewLive needs real workflow data to design effectively. Building it now would be premature optimization.

**Value Proposition**: Will complement (not duplicate) Temporal UI by showing:
- AI-focused metrics (token counts, costs, latency)
- Simplified, beginner-friendly view
- Educational annotations explaining workflow steps
- Link to Temporal UI for detailed execution data

---

## Tasks

See `docs/tasks/tasks-001-ui-mockup.md` for detailed implementation checklist.

---

## Dependencies

### Before Starting
- Elixir 1.14+ installed
- Phoenix 1.7+ framework knowledge
- Design tool (Figma, Excalidraw, or paper + pen for wireframes)

### Blockers
- None - this is the first feature

---

## Notes

### Design Decisions
- **Low-fidelity wireframes**: Fast iteration, focus on structure over aesthetics
- **No database**: Temporal is source of truth, no need for local persistence in MVP
- **Tailwind CSS**: Utility-first styling for rapid UI development
- **LiveView only**: No separate frontend framework (React, Vue) - leverages Phoenix's real-time capabilities

### Future Considerations
- High-fidelity mockups in Figma (Phase 2+)
- Component library documentation (Storybook equivalent)
- Accessibility review (ARIA labels, keyboard navigation)

---

## References

- [Phoenix LiveView Docs](https://hexdocs.pm/phoenix_live_view)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Temporal AI Cookbook](https://docs.temporal.io/ai-cookbook)

---

**Created**: 2025-11-18
**Last Updated**: 2025-11-18
**Next Review**: After wireframe approval
