# ADR 001: Shared Worker Architecture

**Date**: 2025-11-24
**Status**: Accepted
**Context**: Feature 002 Planning - LiteLLM Pattern Implementation

## Context and Problem Statement

During Feature 002 planning, we needed to decide how to manage Temporal workers for the cookbook examples. The initial consideration was whether to:
1. Start/stop workers from the Phoenix UI per pattern
2. Have separate worker processes for each pattern
3. Use a single shared worker registering all patterns

The core tension was between creating a demo-friendly UI that allows per-pattern worker control versus teaching production-realistic Temporal patterns where workers are infrastructure components, not application-controlled resources.

## Decision Drivers

- **Educational Value**: Should teach correct Temporal patterns that match production usage
- **Production Realism**: Architecture should reflect how Temporal is used in real applications
- **Simplicity**: Minimize implementation complexity while maintaining functionality
- **Demo Capability**: Still need to demonstrate worker failure/recovery for learning
- **Resource Efficiency**: Avoid unnecessary process overhead

## Considered Options

### Option 1: UI-Controlled Per-Pattern Workers
**Description**: Each pattern has its own worker process, started/stopped from Phoenix UI buttons.

**Pros**:
- Clear visual feedback of which examples are active
- Easy to demonstrate Temporal's recovery (stop worker, show queued work, restart)
- Resource efficient (only run workers you're actually using)
- Matches Cookbook tutorial structure (each example isolated)

**Cons**:
- Not production-realistic - production workers are infrastructure-managed, not app-managed
- Teaches pattern that shouldn't be used in real applications
- Added complexity in Phoenix (process supervision logic)
- Potential race conditions (worker starting while workflow dispatched)

**Impact**: High implementation complexity, teaches anti-pattern

### Option 2: Separate Worker Processes (Manual Control)
**Description**: Each pattern has its own worker process, but workers are started/stopped manually via terminal, not from UI.

**Pros**:
- Clear separation between patterns
- Manual control gives users understanding of worker lifecycle
- No Phoenix complexity for worker management

**Cons**:
- Not production-realistic (production uses shared worker pools)
- More processes to manage
- Doesn't teach Temporal's standard pattern of one worker registering multiple workflows

**Impact**: Medium complexity, still not production-realistic

### Option 3: Single Shared Worker (RECOMMENDED)
**Description**: One Python worker process registers all 7 cookbook workflow types. Worker runs as long-lived background process. Phoenix shows worker status but doesn't control it.

**Pros**:
- Production-realistic: Workers are infrastructure, not app-controlled
- Teaches correct Temporal patterns (one worker = capability registry)
- Simpler implementation (one worker process, simpler supervision)
- Matches real-world usage (production apps commonly have 1 worker with 50+ workflows)
- Temporal-standard approach: Task queue routing determines which worker picks up which workflow

**Cons**:
- Less granular control for demos (can't stop individual patterns)
- Requires manual terminal control for failure demonstrations

**Impact**: Low complexity, production-realistic, teaches correct patterns

## Decision Outcome

**Chosen Option**: Option 3 - Single Shared Worker

**Rationale**: 
The primary goal of this project is to teach Temporal patterns through hands-on experimentation. Using a production-realistic architecture is more valuable than UI convenience. The Temporal-standard pattern of one worker registering multiple workflows is how production applications work, and teaching this pattern is more educational than teaching a non-standard approach.

For demo purposes, we can still demonstrate failure/recovery by:
- Providing instructions in the UI for manually stopping the worker terminal
- Showing real-time impact when worker goes offline (workflows queue, worker comes back, workflows complete)
- This approach is actually MORE educational because it shows how Temporal handles infrastructure failures

## Implementation Plan

1. **Python Worker Structure**:
   - Create `workers/cookbook/` module structure
   - Single worker registers all 7 workflow types (placeholders for 6, full implementation for LiteLLM)
   - Task queue: `temporal-cookbook-examples`
   - Worker can be started manually: `python -m workers.cookbook`

2. **Phoenix Integration**:
   - Phoenix never starts/stops workers - they're infrastructure
   - Implement worker health check mechanism (poll Temporal task queue or worker heartbeat)
   - Add worker status indicator to navbar (🟢 Online / 🔴 Offline)
   - Add demo instructions in UI for manual worker control

3. **Worker Management** (Feature 5):
   - Primary approach: Manual terminal control (documented in UI)
   - Optional enhancement: OTP supervision for convenience (not required for MVP)
   - Focus on health monitoring and status visibility

## Consequences

### Positive
- **Production-Realistic Architecture**: Teaches how Temporal is actually used in production
- **Simpler Implementation**: One worker process instead of multiple, no Phoenix worker control logic
- **Correct Patterns**: Users learn the Temporal-standard approach of shared worker pools
- **Better Learning**: Manual worker control actually demonstrates infrastructure concepts better
- **Scalability**: Architecture scales naturally as more patterns are added

### Negative
- **Less UI Convenience**: Can't start/stop workers from UI (mitigated by clear instructions)
- **Manual Demo Setup**: Requires terminal access for failure demonstrations (acceptable trade-off for educational value)
- **Per-Pattern Isolation**: Can't easily isolate patterns for testing (acceptable - patterns are independent workflows)

## Follow-up Actions

- [x] Document this decision in ADR (this file)
- [ ] Update Feature 002 PRD to reflect shared worker approach
- [ ] Update Feature 5 scope to make OTP supervision optional
- [ ] Update PLAN.md and PRD.md to reflect this architecture
- [ ] Implement worker health check mechanism in Feature 2
- [ ] Add demo instructions to UI for manual worker control

## References

- **Temporal Documentation**: [Worker Organization](https://docs.temporal.io/workers)
- **Feature 002 Plan**: Feature 002 with Shared Worker Architecture
- **GitHub Issue**: #2 - Feature 002: LiteLLM Pattern

