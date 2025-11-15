# Documentation Structure Guide

## Standard Documentation Organization

### Core Documentation Structure
```
docs/
├── {project-name}-prd.md                # Product Requirements Document
├── README.md                            # Project overview and quick start
├── sessions/                           # Session-by-session development notes
│   ├── session-001-initial-setup.md
│   ├── session-002-core-features.md
│   ├── session-003-testing-framework.md
│   └── session-NNN-{topic}.md
├── decisions/                          # Architecture Decision Records (ADRs)
│   ├── 001-framework-selection.md
│   ├── 002-database-choice.md
│   ├── 003-deployment-strategy.md
│   └── NNN-{decision-topic}.md
├── architecture/                       # Technical design documentation
│   ├── system-overview.md
│   ├── api-documentation.md
│   ├── database-schema.md
│   └── component-interactions.md
├── workflows/                          # Process and workflow documentation
│   ├── development-workflow.md
│   ├── testing-strategy.md
│   ├── deployment-process.md
│   └── troubleshooting-guide.md
└── research/                          # Investigation and spike notes
    ├── technology-evaluation.md
    ├── performance-analysis.md
    └── competitive-analysis.md
```

## Document Templates & Guidelines

### Session Notes Template
**File**: `docs/sessions/session-{NNN}-{topic}.md`

```markdown
# Session {NNN}: {Topic} - {Date}

## Session Goal
{What you intended to accomplish this session}

## Accomplishments
- {Completed task 1}
- {Completed task 2}
- {Completed task 3}

## Technical Work Completed
### {Feature/Component Name}
- **Files Modified**: {list of files}
- **Key Changes**: {description of changes}
- **Testing**: {tests added/updated}

### {Feature/Component Name}
- **Files Modified**: {list of files}
- **Key Changes**: {description of changes}
- **Testing**: {tests added/updated}

## Issues Resolved
- **Issue #{N}**: {Issue title} - {Resolution summary}
- **Issue #{N}**: {Issue title} - {Resolution summary}

## Blockers Encountered
- **Blocker**: {Description of blocker}
  - **Root Cause**: {What caused the issue}
  - **Resolution**: {How it was resolved or next steps}

## Learning Notes
- **{Technology/Concept}**: {Key insights or lessons learned}
- **{Technology/Concept}**: {Key insights or lessons learned}

## Next Session Plan
- {Next priority task}
- {Next priority task}
- {Follow-up item from blockers}

## Code Commit References
- {Commit hash}: {Commit message}
- {Commit hash}: {Commit message}
```

### Architecture Decision Record Template
**File**: `docs/decisions/{NNN}-{decision-topic}.md`

```markdown
# ADR {NNN}: {Decision Title}

**Date**: {YYYY-MM-DD}
**Status**: {Proposed | Accepted | Rejected | Superseded}
**Context**: {Sprint/Phase when decision was made}

## Context and Problem Statement
{Describe the context and problem statement that led to this decision}

## Decision Drivers
- {Factor that influenced the decision}
- {Factor that influenced the decision}
- {Factor that influenced the decision}

## Considered Options
### Option 1: {Option Name}
- **Pros**: {Advantages}
- **Cons**: {Disadvantages}
- **Impact**: {Implementation complexity, performance, etc.}

### Option 2: {Option Name}
- **Pros**: {Advantages}
- **Cons**: {Disadvantages}
- **Impact**: {Implementation complexity, performance, etc.}

## Decision Outcome
**Chosen Option**: {Selected option}

**Rationale**: {Why this option was selected}

## Implementation Plan
- {Implementation step 1}
- {Implementation step 2}
- {Implementation step 3}

## Consequences
### Positive
- {Positive consequence}
- {Positive consequence}

### Negative
- {Negative consequence and mitigation}
- {Negative consequence and mitigation}

## Follow-up Actions
- [ ] {Action item with owner}
- [ ] {Action item with owner}
- [ ] Review decision in {time period}
```

### API Documentation Template
**File**: `docs/architecture/api-documentation.md`

```markdown
# API Documentation

## Overview
{High-level description of the API}

## Base URL
```
{Base URL for all endpoints}
```

## Authentication
{Authentication method and requirements}

## Endpoints

### {Endpoint Category}

#### {HTTP METHOD} /{endpoint-path}
**Description**: {What this endpoint does}

**Parameters**:
- `{param_name}` (string, required): {Parameter description}
- `{param_name}` (integer, optional): {Parameter description}

**Request Example**:
```json
{
  "field1": "value1",
  "field2": "value2"
}
```

**Response Example**:
```json
{
  "status": "success",
  "data": {
    "field1": "value1",
    "field2": "value2"
  }
}
```

**Error Responses**:
- `400 Bad Request`: {Error description}
- `404 Not Found`: {Error description}
- `500 Internal Server Error`: {Error description}
```

## Documentation Best Practices

### Session Notes Guidelines
1. **Write during the session** - Don't wait until the end
2. **Be specific** - Include file names, function names, line numbers
3. **Document blockers** - Capture what blocked you and how you resolved it
4. **Link to commits** - Reference specific commits for code changes
5. **Plan next steps** - Always end with what comes next

### Decision Documentation
1. **Document when made** - Not after implementation is complete
2. **Include alternatives** - Show what you considered and why you didn't choose it
3. **Capture context** - Future you needs to understand the constraints
4. **Review periodically** - Mark outdated decisions as superseded
5. **Link from code** - Reference ADRs in code comments when relevant

### Architecture Documentation
1. **Keep it current** - Update as the system evolves
2. **Include diagrams** - Visual representations clarify complex interactions
3. **Document the why** - Not just what the system does, but why it's designed that way
4. **Provide examples** - Real code examples are more valuable than abstract descriptions
5. **Layer appropriately** - High-level overviews and detailed technical specs serve different purposes

## Documentation Maintenance

### Weekly Documentation Review
- **Session Notes**: Ensure current session is documented
- **ADRs**: Check if any architectural decisions were made informally
- **Architecture Docs**: Update for any structural changes
- **API Docs**: Verify endpoints match actual implementation

### Monthly Documentation Audit
- **Link Validation**: Check all internal and external links
- **Accuracy Check**: Verify documentation matches current implementation
- **Gap Analysis**: Identify missing documentation areas
- **Cleanup**: Archive or update outdated documentation

### Documentation as Part of Definition of Done
- [ ] Relevant documentation updated
- [ ] New architectural decisions recorded
- [ ] API changes documented
- [ ] Session notes completed
- [ ] Links and references verified

## Tools and Automation

### Recommended Tools
- **Markdown Linting**: Ensure consistent formatting
- **Link Checking**: Automated validation of internal/external links
- **Diagram Tools**: Mermaid, PlantUML, or draw.io for technical diagrams
- **Documentation Generation**: Generate API docs from code annotations

### Integration with Development Workflow
- **PR Templates**: Include documentation checklist
- **Commit Messages**: Reference documentation updates
- **Issue Templates**: Include documentation requirements
- **CI/CD**: Automated documentation builds and deployments