# Pull Request Template

## Standard PR Template
```markdown
## Summary
Brief description of changes made and why.

## Related Issue
Closes #{{ISSUE_NUMBER}}

## Changes Made
- {{CHANGE_DESCRIPTION}}
- {{CHANGE_DESCRIPTION}}
- {{CHANGE_DESCRIPTION}}

## Testing
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Manual testing completed for affected features
- [ ] Edge cases tested

**Test Results:**
```
{{PASTE_TEST_OUTPUT_HERE}}
```

## Breaking Changes
- [ ] No breaking changes
- [ ] Breaking changes documented below

**Breaking Change Details:**
{{DESCRIBE_BREAKING_CHANGES_AND_MIGRATION_PATH}}

## Self-Review Checklist
- [ ] Code follows project style and conventions
- [ ] All functions and classes have appropriate documentation
- [ ] No commented-out code or debug statements
- [ ] Error handling is appropriate
- [ ] Performance impact considered
- [ ] Security considerations addressed

## Deployment Considerations
- [ ] No special deployment steps required
- [ ] Database migrations included (if applicable)
- [ ] Environment variables updated (if applicable)
- [ ] Configuration changes documented

## Screenshots/Demo (if applicable)
{{ADD_SCREENSHOTS_OR_DEMO_LINKS_FOR_UI_CHANGES}}

---

### Reviewer Notes
{{ANYTHING_SPECIFIC_FOR_REVIEWERS_TO_FOCUS_ON}}
```

## GitHub PR Template Setup

### Creating .github/pull_request_template.md
```markdown
## Summary
Brief description of changes made and why.

## Related Issue
Closes #

## Changes Made
- 
- 
- 

## Testing
- [ ] All existing tests pass: `{{TEST_COMMAND}}`
- [ ] New tests added for new functionality
- [ ] Manual testing completed for affected features
- [ ] Edge cases tested

**Test Results:**
```
# Paste test command output here
```

## Breaking Changes
- [ ] No breaking changes
- [ ] Breaking changes documented below

**Breaking Change Details:**
<!-- If breaking changes exist, describe them and provide migration path -->

## Self-Review Checklist
- [ ] Code follows project style and conventions
- [ ] All functions and classes have appropriate documentation  
- [ ] No commented-out code or debug statements
- [ ] Error handling is appropriate
- [ ] Performance impact considered
- [ ] Security considerations addressed (no secrets, proper input validation)

## Deployment Considerations
- [ ] No special deployment steps required
- [ ] Database migrations included (if applicable)
- [ ] Environment variables updated (if applicable)
- [ ] Configuration changes documented

## Screenshots/Demo (if applicable)
<!-- Add screenshots for UI changes or links to demo videos -->

---

### Reviewer Notes
<!-- Anything specific you want reviewers to focus on -->
```

## Usage Instructions

### Setting Up PR Template

1. **Create GitHub PR Template:**
   ```bash
   mkdir -p .github
   cp PR_TEMPLATE.md .github/pull_request_template.md
   ```

2. **Customize for Your Project:**
   - Replace `{{TEST_COMMAND}}` with your actual test command
   - Add project-specific sections (deployment, security, etc.)
   - Update checklist items based on your standards

### PR Creation Workflow

#### Before Creating PR
1. **Run Self-Review Checklist:**
   ```bash
   # Run tests
   {{TEST_COMMAND}}
   
   # Check code formatting
   {{FORMAT_COMMAND}}
   
   # Run linter if available
   {{LINT_COMMAND}}
   ```

2. **Verify Issue Completion:**
   - All acceptance criteria met
   - Tests written and passing
   - Documentation updated

#### During PR Creation
1. **Fill out template completely** - don't skip sections
2. **Include test results** - copy/paste actual command output
3. **Add screenshots** for UI changes
4. **Document breaking changes** thoroughly
5. **Request specific feedback** in reviewer notes

#### After PR Creation
1. **Self-review your own PR** before requesting review
2. **Check automated tests** pass in CI/CD
3. **Respond to feedback** promptly
4. **Update branch** if main/master has moved ahead

### PR Size Guidelines

#### Small PR (Preferred)
- **Lines Changed**: < 300 lines
- **Files Changed**: < 10 files  
- **Review Time**: < 30 minutes
- **Scope**: Single feature, bug fix, or refactor

#### Medium PR (Acceptable)
- **Lines Changed**: 300-800 lines
- **Files Changed**: 10-20 files
- **Review Time**: 30-60 minutes
- **Scope**: Complex feature or multiple related changes

#### Large PR (Avoid)
- **Lines Changed**: > 800 lines
- **Files Changed**: > 20 files
- **Review Time**: > 60 minutes
- **Recommendation**: Break into smaller PRs

### Review Response Guidelines

#### Receiving Feedback
- **Acknowledge all comments** even if not making changes
- **Ask clarifying questions** when feedback is unclear
- **Push back respectfully** if you disagree with suggestions
- **Mark conversations resolved** after addressing feedback

#### Addressing Changes
- **Make requested changes** in new commits (don't squash during review)
- **Respond to each comment** explaining what you changed
- **Test changes** before pushing updates
- **Re-request review** after making significant changes

### Merge Criteria

#### Ready to Merge Checklist
- [ ] All acceptance criteria from original issue met
- [ ] All tests passing (including CI/CD)
- [ ] All review feedback addressed
- [ ] No merge conflicts
- [ ] Branch up to date with main/master
- [ ] Self-review completed and documented

#### Post-Merge Cleanup
- [ ] Issue automatically closed (or close manually)
- [ ] Delete feature branch
- [ ] Update project board if using one
- [ ] Add `completed` label to issue
- [ ] Update milestone progress