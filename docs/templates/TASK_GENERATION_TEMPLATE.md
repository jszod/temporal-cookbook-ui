# Implementation Tasks: {{FEATURE_NAME}}

<!--
Task generation template for breaking down feature PRDs into implementation steps.
This template follows hierarchical task breakdown: Parent tasks → Sub-tasks

Inspired by: https://github.com/snarktank/ai-dev-tasks
License: Apache 2.0

USAGE:
1. Generate this file AFTER completing feature PRD
2. Save to: docs/tasks/tasks-{{FEATURE_NAME}}.md
3. Link from GitHub issue
4. Check off tasks as you complete them (- [ ] → - [x])
5. Commit task file updates with code changes
-->

**Feature PRD**: docs/features/{{FEATURE_NAME}}-prd.md
**GitHub Issue**: #{{ISSUE_NUMBER}}
**Status**: {{Not Started|In Progress|Completed}}
**Last Updated**: {{DATE}}

---

## Relevant Files

<!-- List files that will be created or modified, with brief justification -->

### Files to Create
- `{{file_path}}` - {{Purpose and rationale}}
- `{{file_path}}.test.{{ext}}` - {{Test coverage for above}}
- `{{file_path}}` - {{Purpose and rationale}}

### Files to Modify
- `{{file_path}}` - {{What changes are needed and why}}
- `{{file_path}}` - {{What changes are needed and why}}

---

## Implementation Tasks

<!--
Task Hierarchy:
- 0.0: Always start with branch creation
- 1.0, 2.0, 3.0: Parent tasks (high-level steps)
- 1.1, 1.2, 1.3: Sub-tasks (detailed implementation steps)

Progress Tracking:
- Update individual sub-tasks as you complete them
- Parent task is complete when all sub-tasks are done
-->

### Setup
- [ ] **0.0 Create feature branch**
  - Branch name: `feature/{{FEATURE_NAME}}`
  - Base: `{{main|develop}}`
  - Command: `git checkout -b feature/{{FEATURE_NAME}}`

### {{PARENT_TASK_CATEGORY_1}}
- [ ] **1.0 {{Parent task description}}**
  - [ ] **1.1** {{Specific sub-task with implementation details}}
  - [ ] **1.2** {{Specific sub-task with implementation details}}
  - [ ] **1.3** {{Specific sub-task with implementation details}}

### {{PARENT_TASK_CATEGORY_2}}
- [ ] **2.0 {{Parent task description}}**
  - [ ] **2.1** {{Specific sub-task with implementation details}}
  - [ ] **2.2** {{Specific sub-task with implementation details}}
  - [ ] **2.3** {{Specific sub-task with implementation details}}
  - [ ] **2.4** {{Specific sub-task with implementation details}}

### {{PARENT_TASK_CATEGORY_3}}
- [ ] **3.0 {{Parent task description}}**
  - [ ] **3.1** {{Specific sub-task with implementation details}}
  - [ ] **3.2** {{Specific sub-task with implementation details}}

### Testing & Quality
- [ ] **4.0 Write comprehensive tests**
  - [ ] **4.1** Unit tests for {{component}}
  - [ ] **4.2** Integration tests for {{workflow}}
  - [ ] **4.3** Edge case coverage for {{scenario}}
  - [ ] **4.4** All tests passing

### Documentation & Integration
- [ ] **5.0 Documentation and cleanup**
  - [ ] **5.1** Update relevant documentation
  - [ ] **5.2** Add code comments for complex logic
  - [ ] **5.3** Update CHANGELOG if applicable
  - [ ] **5.4** Ensure code follows project style guide

### Review & Merge
- [ ] **6.0 Prepare for review**
  - [ ] **6.1** Self-review all changes
  - [ ] **6.2** Verify all acceptance criteria met
  - [ ] **6.3** Create pull request with description
  - [ ] **6.4** Address review feedback
  - [ ] **6.5** Merge to main branch

---

## Task Generation Process

<!-- Document how these tasks were generated -->

**Generated from**: {{Feature PRD reference}}
**Generation method**: {{AI-assisted|Manual breakdown|Hybrid}}
**Complexity estimate**: {{Simple|Medium|Complex}}
**Estimated effort**: {{X hours/days}}

---

## Progress Tracking

<!-- Update this section as work progresses -->

### Completed Tasks Summary
- **Total tasks**: {{X}}
- **Completed**: {{Y}}
- **Remaining**: {{Z}}
- **Progress**: {{Y/X * 100}}%

### Current Focus
{{Which task is actively being worked on}}

### Blockers
{{Any impediments to progress}}

### Notes & Decisions
{{Implementation notes, architectural decisions, gotchas discovered}}

---

## Example Task Breakdown

<!--
This example shows the level of detail expected for sub-tasks.
Remove this section when creating actual task files.
-->

### Example: Database Schema
- [ ] **1.0 Create user authentication schema**
  - [ ] **1.1** Create migration file: `migrations/001_create_users_table.sql`
  - [ ] **1.2** Add `users` table with columns: id, email, password_hash, created_at
  - [ ] **1.3** Add unique constraint on email column
  - [ ] **1.4** Add indexes on email for lookup performance
  - [ ] **1.5** Run migration in development environment
  - [ ] **1.6** Verify schema matches requirements in PRD

### Example: API Endpoint
- [ ] **2.0 Implement user registration endpoint**
  - [ ] **2.1** Create route handler: `POST /api/register`
  - [ ] **2.2** Add request validation (email format, password strength)
  - [ ] **2.3** Implement password hashing with bcrypt (salt rounds: 12)
  - [ ] **2.4** Insert user record into database with error handling
  - [ ] **2.5** Return appropriate status codes (201 success, 400 validation, 409 duplicate)
  - [ ] **2.6** Add rate limiting to prevent abuse

---

## Integration with TodoWrite

During actual implementation sessions, use TodoWrite for micro-task planning:

**TodoWrite Example** (real-time session tracking):
```
✓ Implementing email validation
  - Set up validator function
  - Add regex pattern for email
  - Add DNS check for domain
  - Write tests for edge cases
```

**This file** (permanent task record):
- Tracks overall feature progress
- Version controlled alongside code
- Shows what was planned vs. what was done

---

<!--
REMINDERS:
✓ Check off tasks as you complete them (change [ ] to [x])
✓ Commit this file with related code changes
✓ Update "Current Focus" section during work
✓ Document blockers and decisions as you encounter them
✓ Update GitHub issue checklist only when major tasks complete
✓ Use TodoWrite for session-level micro-tasks
-->
