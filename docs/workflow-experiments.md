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

### [EXP-002] Git Workflow & Branching Policy
**Status**: ✅ Ready for Integration
**Date Started**: 2025-11-25
**Problem**: Main branch violation occurred - template integration work done directly on `main` instead of feature branch. No clear branching policy documented.

**Root Cause**: CLAUDE.md template lacks explicit git branching requirements, making it easy to accidentally commit to main.

**Changes Made**:
1. Added comprehensive "Git Workflow & Branching Policy" section to CLAUDE.md
2. Critical rule: ALL development on feature branches (no exceptions except emergency hotfixes)
3. Detailed workflow process with commands
4. Branch naming conventions
5. Rationale for why it matters
6. Recovery instructions for accidental main commits

**Files Modified**:
- `CLAUDE.md` lines 112-202 (new "Git Workflow & Branching Policy" section)

**Integration Target**:
- **Repo**: `claude-code-workflow-template`
- **File**: `template-structure/CLAUDE.md.template`
- **Location**: After "Development Environment" section
- **Action**: Copy entire "Git Workflow & Branching Policy" section verbatim

**Priority**: ⚠️ HIGH - Prevents workflow violations in all future projects

**Validation**: Tested immediately by creating `feature/git-workflow-documentation` branch for this work

**Template PR**: [pending]

**Notes**:
- This violation was caught because user enforces workflow discipline
- Clear documentation would have prevented the mistake
- Section includes recovery instructions for when violations occur

---

### [EXP-003] Workflow Automation Prompts Integration
**Status**: 🤔 Needs Discussion
**Date Started**: 2025-11-25
**Problem**: `prd-evolution-prompt.md` and `context-audit-prompt.md` not copied during project initialization. Init script copies `template-structure/` but not `templates/` directory.

**Root Cause**: Workflow prompts live in `templates/workflows/` which is designed as reference material, not auto-copied structure.

**Current Workaround**: Manual copy from template repo when needed.

**Options for Integration**:
1. **Option A**: Modify `setup/init.sh` to copy workflow prompts to `docs/workflows/`
2. **Option B**: Add post-init checklist to template README
3. **Option C**: Document in CLAUDE.md.template that prompts need manual copying

**Recommendation**: **Option A + Option B** (copy automatically + checklist verification)

**Rationale**: These prompts are referenced in CLAUDE.md AI-Optimized Development Protocols section, so they should be immediately available.

**Files Modified** (in this project):
- Copied `prd-evolution-prompt.md` → `docs/workflows/`
- Copied `context-audit-prompt.md` → `docs/workflows/`

**Integration Target**:
- **Repo**: `claude-code-workflow-template`
- **File**: `setup/init.sh`
- **Changes**: Add workflow prompts to template-structure/ or copy them in init script

**Priority**: 🔶 MEDIUM - Improves workflow automation availability

**Template PR**: [pending discussion]

**Notes**:
- CLAUDE.md references these prompts but they weren't present
- User discovered this during workflow investigation
- Need to decide: should these be in template-structure or remain reference?

---

### [EXP-004] Feature Template Location Strategy
**Status**: ✅ Working Well (Document Pattern)
**Date Started**: 2025-11-25
**Problem**: Feature PRD and task generation templates exist in workflow repo but weren't in project. Unclear if they should be copied or referenced.

**Root Cause**: Templates designed as reference materials, not project-specific files.

**Approach Taken**: Copied `FEATURE_PRD_TEMPLATE.md` and `TASK_GENERATION_TEMPLATE.md` to `docs/templates/` in project.

**Benefits Discovered**:
- Templates version-controlled with project
- Easy to customize for project-specific needs
- No external dependency during development
- Can evolve templates based on project learnings

**Changes Made**:
- Created `docs/templates/` directory
- Copied FEATURE_PRD_TEMPLATE.md, TASK_GENERATION_TEMPLATE.md
- Created `docs/templates/README.md` with comprehensive usage guide

**Files Created**:
- `docs/templates/FEATURE_PRD_TEMPLATE.md`
- `docs/templates/TASK_GENERATION_TEMPLATE.md`
- `docs/templates/README.md` (130 lines of usage guidance)

**Integration Target**:
- **Repo**: `claude-code-workflow-template`
- **File**: `template-structure/CLAUDE.md.template` and/or `README.md`
- **Action**: Document this pattern as recommended approach
- **Optional**: Add `docs/templates/` to template-structure with README

**Priority**: 🟢 LOW - Current approach works, documentation sufficient

**Template PR**: [pending - documentation update]

**Notes**:
- This pattern emerged organically and works well
- Having templates in project enables customization
- Created comprehensive README explaining usage
- Could optionally add empty templates/ dir to template-structure with README placeholder

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
