# Nx Release Changelog Issue Reproduction

## Setup

This repository demonstrates an issue with `nx release changelog` when using `projectsRelationship: 'independent'`.

### Project Structure:
- **utils**: Base library (has release tag `utils@1.0.0`)
- **icons**: Depends on utils (has release tag `icons@1.0.0`)
- **components**: Depends on utils (NO release tag yet - first release)

### Configuration:
- `nx.json` has `projectsRelationship: "independent"` 
- Release tag pattern: `{projectName}@{version}`
- Project changelogs enabled

## The Issue

When running `nx release changelog` for the `components` project (which has never been released):

```bash
npx nx release changelog components --verbose
```

**Expected Behavior:**
The command should only look for git history related to the `components` project itself, since it's configured as independent.

**Actual Behavior:**
The command attempts to get git history and find the latest release tag for the `utils` dependency, even though:
1. `utils` is independent and won't have changelog entries generated
2. The git operations are heavy and unnecessary
3. If `utils` didn't have a release tag, this would cause an error

## Why This Matters

This is problematic because:
- It performs unnecessary heavy git operations on all dependencies
- It can fail if a dependent project doesn't have a release yet (though in this demo, utils does have a tag)
- The dependent projects are independent and shouldn't be considered for changelog generation
- It defeats the purpose of the `independent` configuration

## To Reproduce

1. Clone this repository
2. Run: `npx nx release changelog components --verbose`
3. Observe the verbose output showing git operations on the `utils` dependency
4. (Optional) Remove the `utils@1.0.0` tag and run again to see it fail:
   ```bash
   git tag -d utils@1.0.0
   npx nx release changelog components --verbose
   ```

## Expected Fix

`releaseChangelog()` should not attempt to get the latest release tag for dependent projects when using `projectsRelationship: 'independent'`, because those dependents won't have changelog entries generated anyway.
