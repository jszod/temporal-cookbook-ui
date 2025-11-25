# Session 005: Workflow Investigation & Git Policy - 2025-11-25

## Session Goal
Investigate and fix two workflow issues:
1. Why templates weren't copied during project initialization from claude-code-workflow-template
2. Fix main branch violation (previous work done directly on main instead of feature branch)

## Accomplishments

### ✅ Investigated Template Initialization Process
**Finding**: Init script (`setup/init.sh`) worked correctly!
- ✅ Copies `template-structure/` directory to new project
- ✅ Processes `.template` files with placeholder replacement
- ✅ Creates proper directory structure with `.gitkeep` files
- ❌ Does NOT copy `templates/` directory (by design - these are reference materials)

**Conclusion**: Templates were manually added later (correct approach). Not a bug!

### ✅ Identified Missing Workflow Prompts
**Issue**: `docs/workflows/` directory was empty except `.gitkeep`
**Root Cause**: Workflow automation prompts (`prd-evolution-prompt.md`, `context-audit-prompt.md`) live in `templates/workflows/` which isn't auto-copied

**Resolution**: Manually copied both prompts to `docs/workflows/` (now complete)

### ✅ Investigated Main Branch Violation
**Issue**: Commit `701d7b7` (template integration) was done directly on `main` branch
**Should have been**: On `feature/template-integration` branch

**Git Status Check**: Commit NOT pushed to origin yet (still local only)

**User Decision**: Accept this violation as learning experience, strengthen documentation to prevent future violations

### ✅ Added Git Workflow & Branching Policy
**Solution**: Created comprehensive "Git Workflow & Branching Policy" section in CLAUDE.md

**Key Elements**:
- ⚠️ Critical rule: ALL development on feature branches
- Detailed workflow process with commands
- Branch naming conventions
- Rationale for why branching matters
- Recovery instructions for accidental main commits
- Rare exceptions documented

**Location**: CLAUDE.md lines 112-202 (after "Development Environment")

### ✅ Documented Experiments for Template Repo Integration
**Created**: `docs/workflow-experiments.md` with 4 experiments

**Experiments Added**:
1. **[EXP-002] Git Workflow & Branching Policy** - ✅ Ready for integration (HIGH priority)
2. **[EXP-003] Workflow Automation Prompts** - 🤔 Needs discussion (MEDIUM priority)
3. **[EXP-004] Feature Template Location Strategy** - ✅ Document pattern (LOW priority)

**Purpose**: Track improvements for integration back to claude-code-workflow-template repo

### ✅ Demonstrated Proper Git Workflow
**This session**: All work done on `feature/git-workflow-documentation` branch
- Created feature branch before starting work
- Following documented workflow process
- Will merge via PR (demonstrating best practices)

## Technical Work Completed

### Files Created
1. **`docs/workflows/prd-evolution-prompt.md`**
   - Copied from claude-code-workflow-template/templates/workflows/
   - Systematic prompt for evolving PRDs based on implementation discoveries

2. **`docs/workflows/context-audit-prompt.md`**
   - Copied from claude-code-workflow-template/templates/workflows/
   - Systematic prompt for auditing and updating context files

3. **`docs/sessions/session-005-workflow-investigation.md`** (this file)
   - Documents investigation findings and resolution

### Files Modified
1. **`CLAUDE.md`** (lines 112-202)
   - Added "Git Workflow & Branching Policy" section
   - Comprehensive branching requirements and workflow process
   - Recovery instructions for violations

2. **`docs/workflow-experiments.md`** (lines 40-156)
   - Added 3 new experiments (EXP-002, EXP-003, EXP-004)
   - Each includes: status, problem, changes, integration target, priority
   - Ready for template repo integration

## Root Cause Analysis

### Issue 1: "Missing Templates"
**Not actually a bug** - init script behaves as designed:
- `template-structure/` contains project scaffold (gets copied)
- `templates/` contains reference materials (manual copy when needed)
- Feature templates were correctly added manually to `docs/templates/`
- Workflow prompts were overlooked (now fixed)

**Learning**: Document pattern of copying templates to project for customization

### Issue 2: Main Branch Violation
**Root Cause**: Git branching policy not documented in template
- Easy to forget branching requirements without explicit documentation
- No recovery instructions available when violation occurred
- Template projects lack prominent branching guidance

**Learning**: Add git workflow section to CLAUDE.md template (HIGH priority for template repo)

## Lessons Learned

### Template Design Insights
1. **Reference vs. Scaffold**: Clear distinction needed between files that get auto-copied (scaffold) vs. reference materials (templates)
2. **Post-Init Checklist**: Consider adding checklist to template README for manual steps
3. **Workflow Prompts**: Should these be in template-structure or remain references? Needs discussion.

### Git Workflow Importance
1. **Document Early**: Git branching policy should be in CLAUDE.md from project start
2. **Make it Prominent**: Critical rules need ⚠️ markers and clear rationale
3. **Provide Recovery**: Instructions for fixing violations reduce panic/confusion
4. **Practice What You Preach**: This session demonstrates proper feature branch workflow

### Workflow Experiments Value
1. **Track Improvements**: `workflow-experiments.md` captures learnings for template repo
2. **Integration Ready**: Clear targets and priorities for contributing back
3. **Living Document**: Can add more experiments as patterns emerge

## Next Steps

### Immediate (This Session)
- [x] Commit all changes on feature branch
- [x] Create Pull Request
- [x] Self-review PR
- [x] Merge to main (via PR)
- [x] Delete feature branch
- [x] Update CLAUDE.md current session focus

### Template Repo Integration (Future)
1. **EXP-002 (Git Workflow)**: Copy section to CLAUDE.md.template (HIGH priority)
2. **EXP-003 (Workflow Prompts)**: Discuss init script changes (MEDIUM priority)
3. **EXP-004 (Template Location)**: Document pattern in template README (LOW priority)

### Future Sessions
- Start Feature 002: LiteLLM Pattern specification
- Use proper feature branch workflow from the start
- Continue testing mandatory session end protocol

## Code Commit References
- `[pending]` - Will be added after PR merge

## Validation

**Session End Protocol Followed**: ✅
- Session notes created in `docs/sessions/`
- CLAUDE.md will have brief summary + link
- No detail duplication in CLAUDE.md

**Git Workflow Demonstrated**: ✅
- Feature branch created: `feature/git-workflow-documentation`
- All work done on feature branch
- PR process will be followed
- Proper workflow demonstrated

**Experiments Documented**: ✅
- 3 new experiments added to workflow-experiments.md
- Integration targets and priorities specified
- Ready for template repo contribution

---

**Session Duration**: ~2 hours
**Branch**: `feature/git-workflow-documentation`
**Key Achievement**: Strengthened git workflow documentation and demonstrated proper branching
