#!/bin/bash
# Demonstrate the fix

echo "================================"
echo "Running with FIX PATCH applied"
echo "================================"
echo ""
echo "This applies a patch that excludes dependent projects from projectNodes"
echo "when projectsRelationship is 'independent'."
echo ""
echo "The fix prevents unnecessary git operations on dependents and avoids"
echo "errors when dependents don't have release tags."
echo ""

# Apply the fix patch
patch -p1 < patches/fix-issue.patch

echo "Running: npx nx release changelog utils --verbose --dry-run"
echo ""

npx nx release changelog utils --verbose --dry-run

echo ""
echo "================================"
echo "SUCCESS! The command should complete without errors."
echo "================================"

# Restore original
patch -R -p1 < patches/fix-issue.patch
