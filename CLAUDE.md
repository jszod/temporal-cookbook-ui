# Claude Code Development Context

## Project Overview
Web-based front end for running, visualizing, and interacting with examples from the official Temporal.io Cookbook - {{BRIEF_TECHNICAL_SUMMARY}}.

## Project Requirements & Specification
**PRD Location**: `docs/temporal-cookbook-ui-prd.md`
**Status**: {{PRD_STATUS}} <!-- Draft/Complete/Needs Update -->

### Quick Reference
- **Problem Statement**: {{PROBLEM_SUMMARY}}
- **Target Users**: {{PRIMARY_USER_DESCRIPTION}}
- **Core Value Proposition**: {{VALUE_PROPOSITION}}
- **Success Metrics**: {{KEY_SUCCESS_METRICS}}

### PRD Development Process
<!-- Track PRD creation and updates -->
- {{DATE}}: {{PRD_MILESTONE}} ({{STATUS}})
- {{DATE}}: {{PRD_MILESTONE}} ({{STATUS}})

**Next PRD Review**: {{NEXT_PRD_REVIEW_DATE}}

## Current Development Plan
**Plan Location**: `docs/PLAN.md`
**Sprint Goal**: {{SPRINT_GOAL}}
**Active Features**: See PLAN.md for full list

## Current Session Focus
**Session**: {{SESSION_DESCRIPTION}}
**Date**: {{SESSION_DATE}}
**Current Issue**: [#{{ISSUE_NUMBER}} - {{ISSUE_TITLE}}]({{ISSUE_URL}}) {{STATUS_EMOJI}}
**Branch**: `{{BRANCH_NAME}}`
**Previous Success**:
{{LIST_RECENT_ACCOMPLISHMENTS}}

**Current Goals**:
{{LIST_SESSION_GOALS}}

**Status**: {{SESSION_STATUS}}
**Next Session**: {{NEXT_SESSION_FOCUS}}

## Development Environment
<!-- Customize these commands for your technology stack -->
- **Install Dependencies**: `{{PACKAGE_MANAGER_INSTALL}}`
- **Run Tests**: `{{PACKAGE_MANAGER_TEST}}`
- **Format Code**: `{{PACKAGE_MANAGER_FORMAT}}`
- **Lint Code**: `{{PACKAGE_MANAGER_LINT}}`
- **Type Check**: `{{PACKAGE_MANAGER_TYPECHECK}}`
- **Run CLI/Application**: `{{PACKAGE_MANAGER_RUN}}`
- **{{PROJECT_AUTH_COMMAND}}**: `{{AUTH_DESCRIPTION}}`
<!-- Add any additional development commands -->
{{ADDITIONAL_DEV_COMMANDS}}

### Code Quality Configuration
**For Python projects with black formatter:**
```ini
# .flake8
[flake8]
max-line-length = 88
extend-ignore = E203, W503
```

**For other languages:**
<!-- Configure your linter to align with your formatter -->
{{LANGUAGE_SPECIFIC_LINT_CONFIG}}

**Code Quality Standards:**
- All lint checks must pass before committing
- Align linter line length with formatter settings
- Focus on actionable code quality issues, not formatting noise

## Architecture Decisions Made
**ADR Location**: `docs/decisions/`
**Current Decisions**:
- [ADR-001: {{FIRST_DECISION_TITLE}}](docs/decisions/001-{{FIRST_DECISION_FILE}}.md) - {{STATUS}}
- [ADR-002: {{SECOND_DECISION_TITLE}}](docs/decisions/002-{{SECOND_DECISION_FILE}}.md) - {{STATUS}}

### ADR Guidelines
- Create ADR for major architectural decisions before implementation
- Use template in `docs/decisions/TEMPLATE.md`  
- Update index in `docs/decisions/README.md` when adding new ADRs
- Reference related GitHub issues and document alternatives considered
- Include both positive and negative consequences of decisions

## Current Phase Issues (GitHub Milestone)
<!-- Link to your GitHub issues and track progress -->
- [ ] [#{{ISSUE_NUMBER}} - {{ISSUE_TITLE}}]({{ISSUE_URL}})
- [ ] [#{{ISSUE_NUMBER}} - {{ISSUE_TITLE}}]({{ISSUE_URL}})
- [ ] [#{{ISSUE_NUMBER}} - {{ISSUE_TITLE}}]({{ISSUE_URL}})
<!-- Add all issues in current milestone -->

## Key Files & Components
<!-- Organize by your project's architecture -->
**{{COMPONENT_CATEGORY}}:**
- `{{FILE_PATH}}` - {{FILE_DESCRIPTION}}
- `{{FILE_PATH}}` - {{FILE_DESCRIPTION}}

**{{COMPONENT_CATEGORY}}:**
- `{{FILE_PATH}}` - {{FILE_DESCRIPTION}}
- `{{FILE_PATH}}` - {{FILE_DESCRIPTION}}

**Configuration:**
- `{{CONFIG_PATH}}` - {{CONFIG_DESCRIPTION}}
- `{{CONFIG_PATH}}` - {{CONFIG_DESCRIPTION}}

## Session Documentation

### Session Types & Templates

Choose the appropriate session type based on your work:

#### Standard Implementation Session
**Use for**: Successful feature implementations, bug fixes, standard development work
**Template**: [SESSION_TEMPLATE.md](docs/sessions/SESSION_TEMPLATE.md)
**When to use**:
- Implementing features with clear requirements
- Bug fixes with known solutions
- Standard development tasks
- Refactoring and optimization work

#### Investigation Session
**Use for**: Multiple failed approaches, research sessions, blocked/complex implementations
**Template**: [SESSION_INVESTIGATION_TEMPLATE.md](docs/sessions/SESSION_INVESTIGATION_TEMPLATE.md)
**When to use**:
- Multiple implementation approaches have failed
- Technical blockers require architectural research
- Complex requirements need feasibility analysis
- Deep technical investigations are required

**Investigation Session Structure**:
- **Document all approaches attempted** with evidence of failures
- **Identify root technical blockers** preventing progress
- **Capture what actually works** to preserve functional components
- **Extract technical lessons learned** for future work
- **Provide research phase recommendations** for next attempts

### Current Session Notes
**Session {{SESSION_NUMBER}}** - {{SESSION_DATE}}
- **Focus**: {{SESSION_FOCUS}}
- **Accomplishments**: {{SESSION_ACCOMPLISHMENTS}}
- **Blockers Encountered**: {{SESSION_BLOCKERS}}
- **Next Steps**: {{SESSION_NEXT_STEPS}}

### Recent Changes
*Track significant changes here each session*
- {{DATE}}: {{CHANGE_DESCRIPTION}}
- {{DATE}}: {{CHANGE_DESCRIPTION}}

### Session Archive
- **Session {{PREV_SESSION_NUMBER}}** ({{PREV_SESSION_DATE}}): {{PREV_SESSION_SUMMARY}} - [Session Notes](docs/sessions/session-{{PREV_SESSION_NUMBER}}.md)
- **Session {{PREV_SESSION_NUMBER}}** ({{PREV_SESSION_DATE}}): {{PREV_SESSION_SUMMARY}} - [Session Notes](docs/sessions/session-{{PREV_SESSION_NUMBER}}.md)

### Documentation Structure
```
docs/
├── sessions/                    # Session-by-session development notes
│   ├── SESSION_TEMPLATE.md     # Template for standard implementation sessions
│   ├── SESSION_INVESTIGATION_TEMPLATE.md # Template for research/blocked sessions
│   ├── session-001-initial-setup.md
│   ├── session-002-feature-development.md
│   └── session-003-testing-implementation.md
├── decisions/                   # Architecture Decision Records
│   ├── README.md               # ADR index and guidelines
│   ├── TEMPLATE.md             # Template for new ADRs
│   ├── 001-initial-architecture.md # First major architectural decision
│   └── 002-{{NEXT_DECISION}}.md    # Subsequent decisions as needed
├── temporal-cookbook-ui-prd.md      # Product Requirements Document
├── patterns/                    # Proven implementation patterns
│   ├── TEXT_PROCESSING_PATTERN.md # Two-phase text processing architecture
│   ├── VISUAL_TESTING_PATTERN.md  # Multi-level visual quality testing
│   ├── API_OPTIMIZATION_PATTERN.md # Batched API operations strategy
│   └── AI_DEVELOPMENT_PATTERN.md  # AI-optimized PRD evolution framework
└── architecture/                # Technical documentation
    ├── system-overview.md
    └── api-documentation.md
```

## Issues & Blockers
*{{CURRENT_ISSUES_OR_NONE}}*

## AI-Optimized Development Protocols

This template includes proven patterns for effective human-AI collaboration discovered through real project development.

### AI Development Framework
**Quick Reference**: [AI Development Pattern](docs/patterns/AI_DEVELOPMENT_PATTERN.md)

**Key Concepts**:
- **Requirement Specificity Levels**: HIGH (AI-ready) / MEDIUM (collaboration) / LOW (human-driven)
- **PRD Evolution Triggers**: When and how requirements should evolve during development
- **Human-AI Collaboration**: Clear responsibility delineation and handoff patterns
- **Enhanced Session Protocols**: PRD evolution checks integrated into development workflow

**When to Use**:
- AI-assisted development projects requiring iterative requirement refinement
- Projects where implementation discoveries drive requirement evolution
- Complex technical projects with significant unknowns requiring investigation sessions

### Session Protocol Enhancements

#### Systematic Workflow Integration

**PRD Evolution Workflow**:
- **Trigger Recognition**: Requirements proved wrong, new HIGH SPECIFICITY requirements discovered, or technical constraints invalidated existing requirements
- **Session End Integration**: Step 3 in mandatory session end protocol
- **Systematic Process**: Use `docs/workflows/prd-evolution-prompt.md` for evidence-based requirement updates
- **Efficiency**: Reduces PRD update time from 1-2 hours to 30-45 minutes

**Context Audit Workflow**:
- **Trigger Recognition**: Major architecture changes, core technology shifts, or implementation strategy pivots
- **Session End Integration**: Step 4 in mandatory session end protocol
- **Systematic Process**: Use `docs/workflows/context-audit-prompt.md` for comprehensive documentation updates
- **Efficiency**: Reduces context update time from 2-3 hours to ~1 hour

**Investigation Session Support**:
- **Use [Investigation Session Template](docs/sessions/SESSION_INVESTIGATION_TEMPLATE.md)** for blocked/complex work
- **Document failed approaches** with evidence and root cause analysis
- **Capture breakthrough solutions** for institutional knowledge

## Session Management Protocols

### Session Start Protocol 🚀
**Before starting any development work:**
1. **Update "Current Session Focus"** section above with new session info
2. **Review previous session notes** and next steps
3. **Create TodoWrite plan** for the session objectives (see TodoWrite guidelines below)
4. **Check git status** and ensure clean working directory
5. **Verify {{PROJECT_SPECIFIC_SETUP}}** if needed (customize for your project)

### Enhanced TodoWrite Usage Guidelines
**Use TodoWrite tool for complex multi-step tasks (3+ steps or non-trivial work):**

#### When to Use TodoWrite:
- Complex multi-step tasks requiring planning
- Non-trivial tasks needing systematic tracking
- User explicitly requests todo list
- Multiple tasks provided by user (numbered/comma-separated)
- After receiving new instructions to capture requirements
- **Critical**: Mark tasks as in_progress BEFORE starting work
- **Critical**: Mark tasks as completed IMMEDIATELY after finishing

#### When NOT to Use TodoWrite:
- Single straightforward task
- Trivial tasks completable in <3 simple steps
- Purely conversational/informational tasks

#### TodoWrite Best Practices:
- **Task Descriptions**: Use imperative form ("Run tests", "Fix bug")
- **Active Form**: Present continuous for in_progress ("Running tests", "Fixing bug")
- **One in_progress**: Only one task should be in_progress at a time
- **Real-time Updates**: Update status as you work, don't batch completions
- **Completion Criteria**: Only mark complete when FULLY accomplished
- **Error Handling**: Keep as in_progress if blocked, create new task for resolution

### Session End Protocol ⚠️ **MANDATORY** ⚠️
**🚨 DO NOT END SESSION WITHOUT COMPLETING ALL STEPS:**

1. **Update Session Documentation** above with accomplishments and blockers
2. **Create Session Notes** file in `docs/sessions/session-{{SESSION_NUMBER}}-{{SESSION_TOPIC}}.md`
3. **PRD Evolution Check**: Did this session reveal new requirements or invalidate existing ones?
   - If YES: Run PRD evolution analysis using `docs/workflows/prd-evolution-prompt.md`
   - Update PRD sections with evidence-based requirement changes
   - Document evolution rationale and specificity level changes
4. **Context Audit Check**: Did this session involve major architecture/approach changes?
   - If YES: Run context documentation audit using `docs/workflows/context-audit-prompt.md`
   - Update context files that are now obsolete/incorrect
   - Commit context updates with architectural change documentation
5. **Update GitHub Issues** with progress and next steps
6. **Commit Session Changes** with descriptive commit message
7. **Create Pull Request** (if issue work is complete):
   - Reference issue number in PR title/description
   - Include summary of completed work and test results
   - Self-review before marking ready
   - Merge PR after review
8. **Update Project Board** if using GitHub Projects

**📋 Use TodoWrite to track each step - create todos for session end protocol**

### Workflow Improvements Implemented

**Session End Protocol PR Consistency Fix (Template Update):**
- ✅ **Issue Identified**: Session End Protocol was missing PR creation step, conflicting with Issue Completion workflow
- ✅ **Root Cause**: Multiple workflow descriptions with inconsistent guidance about PR requirements
- ✅ **Solution Applied**: Updated Session End Protocol and Checklist to include mandatory PR creation step
- ✅ **Process Clarified**: All issue work must go through PR process, even in solo development

**Key Learning**: Workflow documentation must be consistent across all sections. Always follow Issue Completion process which mandates PR creation for all changes to maintain proper git history and review practices.

## Next Session Prep
- {{PREP_ITEM}}
- {{PREP_ITEM}}
- {{PREP_ITEM}}

## Learning Goals & Progress Tracking

### Technical Learning Objectives
- **{{TECH_LEARNING_AREA}}**: {{LEARNING_GOAL_DESCRIPTION}}
  - Progress: {{PROGRESS_STATUS}} ({{PROGRESS_PERCENTAGE}}%)
  - Evidence: {{EVIDENCE_OF_LEARNING}}
  - Next Milestone: {{NEXT_LEARNING_MILESTONE}}

- **{{TECH_LEARNING_AREA}}**: {{LEARNING_GOAL_DESCRIPTION}}
  - Progress: {{PROGRESS_STATUS}} ({{PROGRESS_PERCENTAGE}}%)
  - Evidence: {{EVIDENCE_OF_LEARNING}}
  - Next Milestone: {{NEXT_LEARNING_MILESTONE}}

### Project Learning Objectives
- **{{PROJECT_LEARNING_AREA}}**: {{LEARNING_GOAL_DESCRIPTION}}
  - Progress: {{PROGRESS_STATUS}} ({{PROGRESS_PERCENTAGE}}%)
  - Evidence: {{EVIDENCE_OF_LEARNING}}
  - Next Milestone: {{NEXT_LEARNING_MILESTONE}}

### Learning Milestone Review
**Last Review**: {{LAST_REVIEW_DATE}}
**Next Review**: {{NEXT_REVIEW_DATE}}

#### Completed Milestones
- {{COMPLETED_MILESTONE}} ({{COMPLETION_DATE}})
- {{COMPLETED_MILESTONE}} ({{COMPLETION_DATE}})

#### Upcoming Milestones
- {{UPCOMING_MILESTONE}} (Target: {{TARGET_DATE}})
- {{UPCOMING_MILESTONE}} (Target: {{TARGET_DATE}})

## Claude Code Workflow Notes
- **Session Start**: Follow Session Start Protocol above
- **During Session**: Use TodoWrite for task planning and tracking
- **Commit frequently** with clear messages
- **Session End**: Follow Session End Protocol above (MANDATORY)
- Use Claude Code for code generation, debugging, and architecture decisions
- Track learning progress alongside feature development
- Document decision rationale for future reference

### **Session End Checklist** (Copy to TodoWrite):
```
- [ ] Update Current Session Focus in CLAUDE.md
- [ ] Create session notes file: docs/sessions/session-XXX-topic.md
- [ ] Update GitHub issues with progress
- [ ] Commit all session changes
- [ ] Create Pull Request (if issue work complete)
- [ ] Self-review and merge PR
- [ ] Update project board status
```

## Standard Development Workflow

### Issue Management & GitHub Workflow
**Professional solo development practices with team-ready workflows:**

#### Starting Work on an Issue
1. **Assign yourself** to the issue in GitHub
2. **Add `in-progress` label** to show active work
3. **Comment on issue** with branch name:
   ```
   🚀 Starting development on branch `{{BRANCH_PREFIX}}/X-description`
   ```
4. **Update CLAUDE.md** current session focus
5. **Create TodoWrite** plan for the issue

#### During Development
1. **Use TodoWrite** for micro-task tracking within sessions
2. **Commit frequently** with issue references:
   ```
   git commit -m "{{COMMIT_MESSAGE_EXAMPLE}} for #{{ISSUE_NUMBER}}"
   ```
3. **Update GitHub issue checklist** only when major tasks complete:
   - Complete TodoWrite milestone → Check off corresponding GitHub task
   - Don't update for every micro-task, focus on meaningful progress
4. **Run tests** before each commit: `{{TEST_COMMAND}}`

#### Session End Protocol
1. **Update GitHub issue checklist** with completed items
2. **Update CLAUDE.md** with session progress and next steps
3. **Ensure clean commit history** with descriptive messages
4. **Update issue labels** if blocked or needs review

#### Issue Completion
1. **Complete all checklist items** in GitHub issue
2. **Remove `in-progress` label**, add `ready-for-review`
3. **Create Pull Request** with:
   - Reference to issue number
   - Summary of completed work
   - Test results confirmation
   - Any breaking changes or dependencies
4. **Self-review** PR before marking ready

#### Branch & Commit Conventions
- **Branch naming**: `{{BRANCH_PREFIX}}/X-short-description` or `fix/X-short-description`
- **Commit messages**: Include issue reference and clear description
- **PR titles**: "Issue #X: Brief description of changes"

### Testing Requirements
**Every new functionality and change MUST include appropriate tests:**

1. **New Features**: Write comprehensive test coverage including:
   - Happy path functionality tests
   - Error handling and edge cases
   - {{UI_COMPONENT_TESTING}} <!-- Customize for your UI framework -->
   - Integration tests where applicable

2. **Bug Fixes**:
   - Write failing test that reproduces the bug
   - Fix the bug
   - Verify test passes

3. **Changes to Existing Code**:
   - Update existing tests to reflect changes
   - Add new tests for new behavior
   - Ensure all tests continue to pass

4. **Test Strategy by Component Type**:
   <!-- Customize these categories for your project type -->
   - **{{COMPONENT_TYPE}}**: {{TESTING_STRATEGY}}
   - **{{COMPONENT_TYPE}}**: {{TESTING_STRATEGY}}
   - **{{COMPONENT_TYPE}}**: {{TESTING_STRATEGY}}

5. **Test Quality Standards**:
   - Tests should be readable and maintainable
   - Use descriptive test names that explain behavior
   - Avoid testing framework implementation details
   - Focus on behavior rather than implementation
   - Remove tests that fail due to testing framework quirks

6. **Before Committing**:
   - Run full test suite: `{{TEST_COMMAND}}`
   - All tests must pass before creating PRs
   - Include test results in PR descriptions

**Testing Commands:**
<!-- Customize for your testing framework -->
- Run all tests: `{{TEST_COMMAND}}`
- Run specific test file: `{{SPECIFIC_TEST_COMMAND}}`
- Run tests with coverage: `{{COVERAGE_COMMAND}}`
{{ADDITIONAL_TEST_COMMANDS}}

### Performance & API Usage Validation
**Critical for projects using external APIs or services:**

1. **API Usage Analysis**:
   - [ ] Count API calls per major operation
   - [ ] Validate against service quotas/limits
   - [ ] Identify potential batching opportunities
   - [ ] Test with realistic data volumes

2. **Performance Testing**:
   - [ ] Benchmark key operations with realistic data
   - [ ] Test quota/rate limit handling
   - [ ] Validate retry mechanisms and error handling
   - [ ] Monitor resource usage patterns

3. **Early Performance Validation**:
   - Validate performance assumptions during MVP development
   - Don't defer performance testing until after feature completion
   - API efficiency should be considered during architecture decisions

### CLI Testing Requirements (if applicable)
**For command-line interfaces:**

1. **Integration Testing**:
   - [ ] Test all commands with various inputs
   - [ ] Validate help documentation and examples
   - [ ] Test error scenarios and recovery suggestions
   - [ ] Progress indicators and user feedback

2. **User Experience Testing**:
   - [ ] Real-world usage scenarios
   - [ ] Error message clarity and actionability  
   - [ ] Recovery guidance for common failures
   - [ ] Batch operations and edge cases

3. **CLI-Specific Patterns**:
   ```python
   # Example CLI test structure
   def test_command_success(self, cli_runner, mock_dependencies):
       result = cli_runner.invoke(cli, ['command', 'args'])
       assert result.exit_code == 0
       assert 'expected output' in result.output
   ```

### Crisis Issue Management
**When discovering critical blocking issues:**

1. **Immediate Response**:
   - Label as `priority:high` immediately
   - Create separate issue - don't scope-creep existing work
   - Document user impact and temporary workarounds

2. **Assessment Process**:
   - Analyze root cause and architectural implications
   - Create ADR if major architectural change needed
   - Update project timeline and priorities accordingly

3. **Communication**:
   - Update related issues with discovery context
   - Document lessons learned in session notes
   - Consider impact on overall project roadmap

### Project Management & Prioritization

#### Priority Labels
All issues should be tagged with priority levels:
- **`priority:high`** - Critical path items, MVP blockers (red)
- **`priority:medium`** - Important but not blocking (yellow)
- **`priority:low`** - Nice to have, future enhancements (green)

### Milestone Management & Phase Transitions

#### Current Milestone: {{CURRENT_MILESTONE_NAME}}
- **Progress**: {{ISSUES_COMPLETED}}/{{TOTAL_ISSUES}} issues completed ({{COMPLETION_PERCENTAGE}}%)
- **Target Completion**: {{MILESTONE_DUE_DATE}}
- **Status**: {{ON_TRACK_STATUS}} <!-- On Track/At Risk/Delayed -->

#### Milestone Completion Criteria
- [ ] All high-priority issues resolved
- [ ] MVP acceptance criteria met
- [ ] Test coverage target achieved ({{TARGET_COVERAGE}}%)
- [ ] Performance benchmarks met
- [ ] Documentation updated
- [ ] Deployment/release process validated

#### Phase Transition Checklist
**Before Moving to Next Phase:**
- [ ] Current phase Definition of Done completed
- [ ] Learning objectives achieved and documented
- [ ] Technical debt assessed and managed
- [ ] Architecture decisions documented
- [ ] Handoff documentation updated for next phase
- [ ] Retrospective completed and lessons captured

#### Milestone History
- **{{PREV_MILESTONE_NAME}}**: {{COMPLETION_STATUS}} ({{COMPLETION_DATE}})
  - Key Achievements: {{MILESTONE_ACHIEVEMENTS}}
  - Lessons Learned: {{MILESTONE_LESSONS}}
- **{{PREV_MILESTONE_NAME}}**: {{COMPLETION_STATUS}} ({{COMPLETION_DATE}})
  - Key Achievements: {{MILESTONE_ACHIEVEMENTS}}
  - Lessons Learned: {{MILESTONE_LESSONS}}

#### GitHub Project Board Setup (Manual)
**To create the project board:**
1. Go to GitHub repository → Projects tab
2. Create new project: "temporal-cookbook-ui - {{PHASE_NAME}}"
3. Add columns: Backlog, Ready, In Progress, Review, Done
4. Add all issues to Backlog column in priority order

**Project Board Workflow:**
- **When starting an issue**: Move from "Ready" → "In Progress", add `in-progress` label
- **When creating PR**: Move to "Review", change label to `ready-for-review`
- **When PR merged**: Move to "Done", change label to `completed`
- **Add new issues**: Always add to "Backlog" with appropriate priority label

**Current Issue Priority Order:**
1. {{PRIORITY_ISSUE_DESCRIPTION}} (`priority:high`) - {{STATUS}}
2. {{PRIORITY_ISSUE_DESCRIPTION}} (`priority:high`) - {{STATUS}}
3. {{PRIORITY_ISSUE_DESCRIPTION}} (`priority:medium`) - {{STATUS}}

#### Post-Merge Cleanup
After PR is merged:
1. **Remove `ready-for-review` label**, add `completed`
2. **Close issue** (if not auto-closed by PR merge)
3. **Update milestone progress** if applicable
4. **Clean up local branch**: `git branch -d {{BRANCH_PREFIX}}/X-description`
5. **Update project board** by moving issue to "Done" column
