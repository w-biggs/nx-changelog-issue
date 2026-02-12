# Nx Release Changelog Issue Demo

Demonstrates issue with `nx release changelog` when using `projectsRelationship: 'independent'`.

## Setup

- **utils**: has release tag `utils@1.0.0`
- **icons**: depends on utils (no release tag)
- **components**: depends on utils (no release tag)

## Test Cases

### 1. Show the error (stock Nx)
```bash
./demo-stock.sh
```

Runs `npx nx release changelog utils` - errors trying to find tags for dependent projects.

### 2. Show what's happening internally
```bash
./demo-with-logging.sh
```

Applies patch with debug logging to show which projects are being processed.

### 3. Show the fix working
```bash
./demo-with-fix.sh
```

Applies the fix - excludes dependents from `projectNodes` when `projectsRelationship: 'independent'`.

## Patches

- `patches/add-logging.patch` - adds console.log statements
- `patches/fix-issue.patch` - proposed fix excluding dependents for independent projects
