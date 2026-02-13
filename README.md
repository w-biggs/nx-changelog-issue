# Nx Release Changelog Issue Demo

Demonstrates issue with `nx release changelog` when using `projectsRelationship: 'independent'`.

## Setup

- **utils**: has release tag `utils@1.0.0`
- **icons**: depends on utils (no release tag)
- **components**: depends on utils (no release tag)

## Test Cases

Run these in order:

```bash
# 1. Show the error (stock Nx)
npm run demo:stock

# 2. Show what's happening internally  
npm run demo:with-logging

# 3. Show the fix working
npm run demo:with-fix
```

## Patches

- `patches/nx+22.5.0+with-logging.patch` - adds debug logging
- `patches/nx+22.5.0+with-fix.patch` - workaround patch/fix, excluding dependents for independent projects
