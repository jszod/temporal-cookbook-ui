# Feature Development Templates

This directory contains templates for creating comprehensive feature specifications and implementation plans.

## Available Templates

### FEATURE_PRD_TEMPLATE.md
**Purpose**: Comprehensive feature specification template for individual features within the project.

**When to use**:
- Starting work on a new feature listed in GitHub issues
- Need to document requirements, goals, and acceptance criteria
- Before beginning implementation work

**Structure**:
- Introduction/Overview - Feature description and problem statement
- Goals - Primary objectives and success criteria
- User Stories - As a/I want to/So that format with acceptance criteria
- Functional Requirements - Core functionality and user interactions
- Non-Goals - Explicitly out of scope items
- Design Considerations - UI/UX requirements and mockups
- Technical Considerations - Dependencies, integrations, constraints
- Success Metrics - How to measure success and testing strategy
- Open Questions - Clarifications and decisions needed
- Implementation Timeline - Effort estimate and target completion

### TASK_GENERATION_TEMPLATE.md
**Purpose**: Hierarchical task breakdown for implementing features systematically.

**When to use**:
- After completing a feature PRD
- Need to break down feature into concrete implementation steps
- Want to track progress through detailed checkboxes

**Structure**:
- Relevant Files - Files to create/modify with rationale
- Implementation Tasks - Hierarchical breakdown (Parent tasks → Sub-tasks)
  - Setup (branch creation)
  - Implementation categories (feature-specific)
  - Testing & Quality
  - Documentation & Integration
  - Review & Merge
- Progress Tracking - Task counts, current focus, blockers, notes

## Workflow

### Step 1: Create Feature PRD
```bash
# Copy template to features directory
cp docs/templates/FEATURE_PRD_TEMPLATE.md docs/features/feature-XXX-name.md

# Fill out all sections systematically
# Focus on: Problem Statement, Goals, User Stories, Functional Requirements
```

### Step 2: Generate Task List
```bash
# Copy template to tasks directory
cp docs/templates/TASK_GENERATION_TEMPLATE.md docs/tasks/tasks-XXX-name.md

# Break down PRD into hierarchical tasks
# Identify all files to create/modify
```

### Step 3: Link Documents
- Update GitHub issue with links to PRD and task files
- Reference in PLAN.md if needed
- Link from CLAUDE.md current session focus

### Step 4: Implementation
- Follow task list systematically
- Check off tasks as completed (`- [ ]` → `- [x]`)
- Use TodoWrite for session-level micro-tasks
- Commit task file updates with code changes

## Template Customization

### Project-Specific Adaptations
These templates come from `claude-code-workflow-template` but are versioned in this project for customization:

- **Keep the structure**: Core sections provide valuable scaffolding
- **Add project-specific sections**: Add sections relevant to Temporal AI Cookbook UI (e.g., "Temporal Workflow Definition", "LLM Provider Configuration")
- **Remove unused sections**: If a section doesn't apply to your feature, remove it
- **Document changes**: Note significant template customizations in this README

### Template Evolution
As you use these templates, you'll discover improvements:

- **Missing sections**: Add new sections that would have been helpful
- **Confusing guidance**: Clarify instructions or examples
- **Project patterns**: Add project-specific examples to make templates more concrete

**Update process**:
1. Make improvements to templates in this project
2. Document rationale in git commit messages
3. Consider contributing improvements back to `claude-code-workflow-template` repo

## Examples

### Well-Formed Feature PRD
See `docs/features/feature-001-ui-mockup.md` for a good example of:
- Clear problem statement connecting to project goals
- Specific user stories with testable acceptance criteria
- Detailed wireframes and technical implementation plans
- Comprehensive acceptance criteria checklist

### Task Breakdown Best Practices

**Good task structure** (specific, actionable):
```markdown
- [ ] **2.1** Create route handler: `POST /api/register`
- [ ] **2.2** Add request validation (email format, password strength)
- [ ] **2.3** Implement password hashing with bcrypt (salt rounds: 12)
```

**Poor task structure** (vague, not actionable):
```markdown
- [ ] **2.1** Make the registration endpoint
- [ ] **2.2** Add validation
- [ ] **2.3** Handle passwords
```

## Common Mistakes to Avoid

### PRD Mistakes
❌ **Skipping Non-Goals section** - Leads to scope creep
✅ **Explicitly document what's out of scope** - Prevents misunderstandings

❌ **Vague user stories** - "As a user, I want it to work better"
✅ **Specific, testable stories** - "As a developer, I want to select between 4 LLM providers so I can compare workflow behavior across providers"

❌ **No acceptance criteria** - Unclear when feature is "done"
✅ **Concrete, testable criteria** - "All 4 providers (OpenAI, Anthropic, Groq, Ollama) launch workflows successfully"

### Task Breakdown Mistakes
❌ **Tasks too large** - "Implement the whole feature"
✅ **Bite-sized tasks** - 1-2 hours max per sub-task

❌ **Missing file references** - "Update the code"
✅ **Specific files** - "Modify `lib/temporal_cookbook_ui_web/router.ex` to add `/patterns/:id` route"

❌ **No testing tasks** - Assume testing happens magically
✅ **Explicit test tasks** - "Write unit tests for pattern selection logic"

## Integration with TodoWrite

**This file** (permanent task record):
- Tracks overall feature progress
- Version controlled alongside code
- Shows what was planned vs. what was done
- Hierarchical structure (Parent tasks → Sub-tasks)

**TodoWrite** (real-time session tracking):
- Micro-tasks within current work session
- More granular than task file
- Helps maintain focus during implementation
- Not version controlled

**Example workflow**:
1. Task file says: "2.1 Implement email validation function"
2. During session, TodoWrite tracks:
   - Set up validator function
   - Add regex pattern for email
   - Add DNS check for domain
   - Write tests for edge cases

## Questions?

- Check existing feature PRDs in `docs/features/` for examples
- Review task files in `docs/tasks/` for task breakdown patterns
- See `CLAUDE.md` for overall development workflow
- Refer to `docs/documentation-guide.md` for documentation standards

---

**Source**: Templates copied from `claude-code-workflow-template` repository
**License**: Apache 2.0
**Last Updated**: 2025-11-25
