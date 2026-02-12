# Nx Release Changelog Issue Reproduction

## Setup

This repository demonstrates an issue with `nx release changelog` when using `projectsRelationship: 'independent'`.

### Project Structure:
- **utils**: Base library (has release tag `utils@1.0.0`)
- **icons**: Depends on utils (NO release tag - hasn't been released yet)
- **components**: Depends on utils (NO release tag - hasn't been released yet)

### Configuration:
- `nx.json` has `projectsRelationship: "independent"` 
- Release tag pattern: `{projectName}@{version}`
- Project changelogs enabled

## The Issue

When running `nx release changelog utils` (to generate changelog for the utils project only):

```bash
npx nx release changelog utils --verbose
```

**What Happens:**
The code in `changelog.ts` creates a `projectNodes` array that includes not just `utils`, but also its dependents `icons` and `components`. It then iterates through all three projects and tries to find the previous git tag for each one.

**Why This Is Wrong:**
1. The dependent projects (`icons` and `components`) will NEVER have changelog entries generated for them in this run, because `projectsVersionData` only contains `utils`, not the dependents
2. The code errors when it can't find tags for `icons` or `components` (which don't have releases yet)
3. The git operations on dependents are unnecessary and heavy
4. This defeats the purpose of `projectsRelationship: 'independent'`

## Code References

The issue is in this code:
- https://github.com/nrwl/nx/blob/51420790c35e3217caa2142234c58edbd567dd36/packages/nx/src/command-line/release/changelog.ts#L275-L286

At line 278-281, it includes dependent projects in the `projects` array:
```typescript
const projects = specificProjects.length
    ? specificProjects.flatMap((project) => {
            return [
                project,
                ...(projectsVersionData[project]?.dependentProjects.map((dep) => dep.source) || []),
            ];
        })
    : releaseGroup.projects;
```

Then in `generateChangelogForProjects()`:
- https://github.com/nrwl/nx/blob/51420790c35e3217caa2142234c58edbd567dd36/packages/nx/src/command-line/release/changelog.ts#L1092-L1112

When `projects = [{ name: icons }]` but `projectsVersionData = { utils: {...} }`, the check `projectsVersionData[project.name]` is falsy, so no changelog is generated for the dependent project anyway.

## Demonstrations

Three demo scripts are provided:

### 1. `./demo-stock.sh` - Show the issue with stock Nx
Runs `npx nx release changelog utils` with the unmodified Nx code. This will ERROR trying to find tags for dependent projects.

### 2. `./demo-with-logging.sh` - Show what's happening internally
Temporarily patches Nx to add console.log statements showing:
- Which projects are in the `projectNodes` array (includes dependents)
- Which projects actually have version data (only `utils`)
- That dependents are being processed even though they won't get changelogs

### 3. `./demo-with-fix.sh` - Show the proposed fix
Applies a patch that excludes dependent projects from the `projectNodes` array when `projectsRelationship: 'independent'`. This should complete successfully.

## Proposed Fix

In `changelog.ts` around line 278-281, change:
```typescript
const projects = specificProjects.length
    ? specificProjects.flatMap((project) => {
            return [
                project,
                // FIX: For independent projects, don't include dependents
                ...(releaseGroup.projectsRelationship === 'independent' 
                    ? [] 
                    : (projectsVersionData[project]?.dependentProjects.map((dep) => dep.source) || [])),
            ];
        })
    : releaseGroup.projects;
```

This prevents:
- Unnecessary git operations on dependent projects
- Errors when dependents don't have release tags yet
- Processing projects that will never have changelogs generated

