#!/bin/bash
# Demonstrate the issue with stock Nx

echo "================================"
echo "Running with STOCK Nx (no patches)"
echo "================================"
echo ""
echo "This will attempt to run changelog generation on 'utils' project."
echo "The utils project has dependents: 'icons' and 'components'"
echo "Those dependents do NOT have release tags yet."
echo ""
echo "Expected: Should only check git history for 'utils'"
echo "Actual: Will try to check git tags for 'icons' and 'components' and ERROR"
echo ""
echo "Running: npx nx release changelog utils --verbose --dry-run"
echo ""

npx nx release changelog utils --verbose --dry-run
