# Nx Release Changelog Issue Demo

This repository demonstrates an issue with Nx's `release changelog` command when using independent project releases.

## Quick Start

Run the demo scripts in order to see the issue:

```bash
# 1. See the error with stock Nx
./demo-stock.sh

# 2. See what's happening internally with debug logging
./demo-with-logging.sh

# 3. See the proposed fix working
./demo-with-fix.sh
```

## The Problem

When running `nx release changelog` on a project with `projectsRelationship: 'independent'`, Nx unnecessarily attempts to get git history and release tags for all dependent projects, even though:
- Those dependents won't have changelog entries generated
- This causes heavy git operations
- It errors if dependents don't have release tags yet

## Repository Setup

- **utils** - Base library with release tag `utils@1.0.0`
- **icons** - Depends on utils (no release tag)
- **components** - Depends on utils (no release tag)

Configuration in `nx.json`:
- `projectsRelationship: "independent"`
- `releaseTagPattern: "{projectName}@{version}"`

## Full Details

See [reproduce-issue.md](./reproduce-issue.md) for:
- Detailed explanation of the issue
- Links to the problematic code in Nx
- Proposed fix with code changes
- Why this matters for independent project releases

## For Nx Maintainers

The fix is simple - in `changelog.ts` around line 278-281, exclude dependent projects from the `projectNodes` array when `projectsRelationship === 'independent'`.

See `patches/fix-issue.patch` for the proposed change.
