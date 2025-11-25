# Feature PRD: {{FEATURE_NAME}}

<!--
Feature-level PRD template for individual features within a larger project.
This is a lightweight template focusing on specific feature implementation.
For project-level planning, see the main PRD in docs/

Inspired by: https://github.com/snarktank/ai-dev-tasks
License: Apache 2.0
-->

**GitHub Issue**: #{{ISSUE_NUMBER}}
**Status**: {{Planning|In Progress|Completed}}
**Priority**: {{P0|P1|P2|P3}}
**Implementation Tasks**: docs/tasks/tasks-{{FEATURE_NAME}}.md

---

## 1. Introduction/Overview

### Feature Description
{{Brief description of what this feature does}}

### Problem Statement
{{What user problem does this feature solve? Why is it needed?}}

### Connection to Project Goals
{{How does this feature support the overall project vision from the main PRD?}}

---

## 2. Goals

### Primary Objectives
- **{{Goal 1}}**: {{Measurable outcome}}
- **{{Goal 2}}**: {{Measurable outcome}}
- **{{Goal 3}}**: {{Measurable outcome}}

### Success Criteria
{{How will we know this feature is successful? What metrics matter?}}

---

## 3. User Stories

### User Story 1
**As a** {{user type}}
**I want to** {{action}}
**So that** {{benefit}}

**Acceptance Criteria**:
- [ ] {{Specific testable criterion}}
- [ ] {{Specific testable criterion}}
- [ ] {{Specific testable criterion}}

### User Story 2
**As a** {{user type}}
**I want to** {{action}}
**So that** {{benefit}}

**Acceptance Criteria**:
- [ ] {{Specific testable criterion}}
- [ ] {{Specific testable criterion}}

---

## 4. Functional Requirements

### Core Functionality
1. **{{Requirement 1}}**: {{Explicit description of what the system must do}}
2. **{{Requirement 2}}**: {{Explicit description of what the system must do}}
3. **{{Requirement 3}}**: {{Explicit description of what the system must do}}

### User Interactions
- **{{Interaction 1}}**: {{How users interact with this feature}}
- **{{Interaction 2}}**: {{How users interact with this feature}}

### Data Requirements
- **{{Data need 1}}**: {{What data is needed and how it flows}}
- **{{Data need 2}}**: {{What data is needed and how it flows}}

---

## 5. Non-Goals

### Explicitly Out of Scope
- {{What this feature will NOT do}}
- {{What this feature will NOT do}}
- {{What this feature will NOT do}}

### Future Considerations
- {{Features that might be added later but not now}}
- {{Features that might be added later but not now}}

---

## 6. Design Considerations

### User Interface
{{Description of UI/UX requirements}}

### Mockups/Wireframes
{{Link to designs, or description of visual requirements}}

### Interaction Flow
```
{{Step-by-step user flow}}
1. User {{action}}
2. System {{response}}
3. User sees {{result}}
```

### Accessibility
- {{Accessibility requirement}}
- {{Accessibility requirement}}

---

## 7. Technical Considerations

### Dependencies
- **{{Dependency 1}}**: {{Why it's needed}}
- **{{Dependency 2}}**: {{Why it's needed}}

### Integration Points
- **{{Integration 1}}**: {{How this feature connects to existing code}}
- **{{Integration 2}}**: {{How this feature connects to existing code}}

### Constraints
- **{{Constraint 1}}**: {{Technical or business limitation}}
- **{{Constraint 2}}**: {{Technical or business limitation}}

### Files to Modify/Create
{{Reference from task file or initial estimate}}
- `{{file path}}` - {{reason}}
- `{{file path}}` - {{reason}}

---

## 8. Success Metrics

### Measurement Criteria
- **{{Metric 1}}**: {{How to measure, target value}}
- **{{Metric 2}}**: {{How to measure, target value}}

### Testing Strategy
- **Unit Tests**: {{Coverage expectations}}
- **Integration Tests**: {{What to test}}
- **Manual Testing**: {{Test scenarios}}

### Definition of Done
- [ ] All acceptance criteria met
- [ ] Tests written and passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Deployed to {{environment}}

---

## 9. Open Questions

### Clarifications Needed
- [ ] {{Question that needs answering before implementation}}
- [ ] {{Question that needs answering before implementation}}

### Decisions Pending
- [ ] {{Decision point requiring stakeholder input}}
- [ ] {{Decision point requiring stakeholder input}}

---

## Implementation Timeline

**Estimated Effort**: {{X days/hours}}
**Target Completion**: {{Date}}
**Milestone**: {{GitHub milestone name}}

---

## References

- **Main PRD**: docs/{{PROJECT_NAME}}-prd.md
- **Related Issues**: #{{issue}}, #{{issue}}
- **Design Resources**: {{links}}
- **Technical Docs**: {{links}}

---

<!--
USAGE NOTES:
1. Create this file in docs/features/{{FEATURE_NAME}}-prd.md
2. Fill out sections BEFORE generating tasks
3. Use this as input to task generation template
4. Link from GitHub issue for traceability
5. Keep updated as feature evolves during implementation
-->
