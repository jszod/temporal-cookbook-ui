# Context Documentation Audit Prompt

## When to Use This Prompt

Use this comprehensive audit when major architecture or approach changes have occurred that may make context documentation obsolete or incorrect.

### Trigger Conditions

**Run context audit if session involved:**
- Major architecture diagram changes
- Core technology/approach shifts (e.g., database change, API redesign)
- New patterns that solve previously unsolvable problems
- Failed approaches that drive major pivots
- Performance characteristics that significantly change
- Implementation strategies that fundamentally evolve

## Systematic Context Audit Process

**Copy and customize this prompt for your specific change:**

---

## Context Documentation Audit: [CHANGE DESCRIPTION]

Please review and update all context files in `docs/context/` for the following architectural change:

**Change Description**: [Describe the major change - e.g., "Shift from REST API to GraphQL approach"]

**Session Reference**: [e.g., "Session 015 GraphQL implementation breakthrough"]

**Key Impact Areas**: [e.g., "Architecture diagrams, API integration patterns, failed approaches documentation"]

### Systematic Review Process

**Step 1: Read and Analyze Each Context File**
Review these files and identify sections that are now obsolete, incorrect, or missing:

- `docs/context/ARCHITECTURE_CORE.md` - Core architecture decisions and diagrams
- `docs/context/FAILED_APPROACHES.md` - Failed attempts and anti-patterns
- `docs/context/API_INTEGRATION.md` - API integration patterns and guidance
- `docs/context/ACTIVE_PATTERNS.md` - Current implementation patterns
- `docs/context/README.md` - Context navigation and descriptions
- `docs/patterns/` - Implementation pattern files

**Step 2: Create Priority Matrix**
Categorize needed updates by urgency and impact:

| File | Impact Level | Current State | Action Required |
|------|--------------|---------------|-----------------|
| ARCHITECTURE_CORE.md | 🔴 Critical/🟡 Medium/🟠 Low | Obsolete/Outdated/Missing | Complete rewrite/Major update/Addition |
| FAILED_APPROACHES.md | 🔴 Critical/🟡 Medium/🟠 Low | Obsolete/Outdated/Missing | Complete rewrite/Major update/Addition |
| API_INTEGRATION.md | 🔴 Critical/🟡 Medium/🟠 Low | Obsolete/Outdated/Missing | Complete rewrite/Major update/Addition |
| ACTIVE_PATTERNS.md | 🔴 Critical/🟡 Medium/🟠 Low | Obsolete/Outdated/Missing | Complete rewrite/Major update/Addition |
| README.md | 🔴 Critical/🟡 Medium/🟠 Low | Obsolete/Outdated/Missing | Complete rewrite/Major update/Addition |

**Step 3: Update Files in Priority Order**
Focus on 🔴 Critical updates first, then 🟡 Medium, then 🟠 Low.

For each file update:
- **Document evidence** for why changes are needed
- **Preserve working patterns** that are still valid
- **Add new patterns** discovered through the change
- **Update cross-references** and navigation links
- **Include session references** for implementation history

**Step 4: Specific Update Guidance**

**ARCHITECTURE_CORE.md Updates:**
- Architecture diagrams reflecting new approach
- Core decisions documentation with new rationale
- Performance characteristics from new approach
- Component relationships and data flow
- Evolution history showing before/after

**FAILED_APPROACHES.md Updates:**
- Document the critical failure that drove the change
- Include technical evidence and root cause analysis
- Reference attempts and why they failed
- Link to breakthrough solution session

**API_INTEGRATION.md Updates:**
- New API patterns and integration approaches
- Updated authentication and error handling
- Performance optimization strategies
- Migration notes from old to new approach

**ACTIVE_PATTERNS.md Updates:**
- New implementation patterns to follow
- Updated coding standards and best practices
- Pattern examples with working code
- Integration with existing patterns

**README.md Updates:**
- Navigation descriptions reflecting new architecture
- Updated "when to read" guidance for each file
- Cross-reference validation

**Step 5: Validation and Cross-References**
- Ensure all internal links work correctly
- Verify session references are accurate
- Check that navigation makes sense
- Validate code examples are current

**Step 6: Commit Documentation**
Create comprehensive commit message documenting:
- Which files were updated and why
- Evidence for architectural change impact
- Cross-references to breakthrough sessions
- Summary of critical updates vs minor updates

### Expected Outcome

After completing this audit:
- All context files accurately reflect current architecture
- Navigation and cross-references work correctly
- Failed approaches that led to change are documented
- New patterns and best practices are captured
- Future developers have clear guidance
- Session implementation history is preserved

### Efficiency Metrics

**Time Investment**:
- Without systematic prompt: 2-3 hours
- With this prompt: 1 hour guided process
- ROI: Prevents misleading documentation and captures institutional knowledge

---

## Template Customization

**For your specific change, replace these placeholders:**
- `[CHANGE DESCRIPTION]` - Brief description of the architectural change
- `[SESSION REFERENCE]` - Session number and name that drove the change
- `[KEY IMPACT AREAS]` - Specific areas most affected by the change

**Add specific context for your change:**
- Technical details about what changed
- Evidence or session references
- Specific files most impacted
- Timeline and decision rationale

## Success Validation

**Audit is complete when:**
- ✅ All context files accurately reflect current reality
- ✅ No obsolete or misleading information remains
- ✅ New patterns and approaches are documented
- ✅ Failed approaches that drove change are captured
- ✅ Navigation and cross-references work
- ✅ Implementation guidance is current and actionable

This systematic approach ensures comprehensive context updates while minimizing time investment and maximizing institutional knowledge capture.