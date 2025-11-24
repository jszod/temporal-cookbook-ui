# Workflow Experiments

This file tracks workflow improvements being tested in this project before contributing them back to the [claude-code-workflow-template](https://github.com/anthropics/claude-code-workflow-template).

## Active Experiments

### [EXP-001] Mandatory Session End Protocol
**Status**: 🧪 Testing
**Date Started**: 2025-11-24
**Problem**: Session End Protocol exists in CLAUDE.md but gets ignored, leading to documentation duplication in CLAUDE.md instead of creating session notes files.

**Root Cause**: Protocol not prominent enough, easy to skip

**Changes Made**:
1. Added ⚠️ MANDATORY marker to Session End Protocol section
2. Emphasized requirement to create `docs/sessions/session-XXX-topic.md` files
3. Made it explicit: CLAUDE.md = brief summary ONLY + link to session notes
4. Added TodoWrite reminder for Session End Checklist

**Files Modified**:
- `CLAUDE.md` lines 433-443 (Session End Protocol section)
- `CLAUDE.md` lines 30-66 (Current Session Focus - now uses links to session notes)

**Success Criteria**:
- [ ] Complete 3+ sessions following new protocol
- [ ] Zero instances of detail duplication in CLAUDE.md
- [ ] Session notes files consistently created in `docs/sessions/`
- [ ] Each session has link from CLAUDE.md → session notes

**Validation Progress**: 1/3 sessions (Session 004 used new workflow)

**Template PR**: [pending after 3 successful sessions]

**Notes**:
- Session 004: Created `docs/sessions/session-004-feature-001-completion.md` with detailed notes
- CLAUDE.md now has brief summary + link (correct!)

---

## Validated (Ready for Template)

[None yet - experiments need 3+ sessions to validate]

---

## Rejected

[None yet]

---

## How to Use This File

### When Making Workflow Changes:
1. Document new experiment in "Active Experiments" section
2. Include problem, changes, success criteria
3. Test for 2-3 sessions/features
4. Update validation progress

### When Experiment Succeeds:
1. Move to "Validated" section
2. Create issue in claude-code-workflow-template repo
3. Submit PR with experiment details
4. Link PR back to this file

### When Experiment Fails:
1. Move to "Rejected" section
2. Document why it didn't work
3. Capture lessons learned for future experiments

### Template for New Experiments:
```markdown
### [EXP-XXX] Experiment Name
**Status**: 🧪 Testing
**Date Started**: YYYY-MM-DD
**Problem**: [What workflow issue are we solving?]

**Changes Made**:
- [Specific change 1]
- [Specific change 2]

**Files Modified**:
- `file.md` lines X-Y

**Success Criteria**:
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]

**Validation Progress**: X/3 sessions

**Template PR**: [pending/link]

**Notes**:
- Session XXX: [observation]
```
