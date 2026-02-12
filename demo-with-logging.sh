#!/bin/bash
# Demonstrate the issue with added logging to show what's happening

echo "================================"
echo "Running with LOGGING PATCH applied"
echo "================================"
echo ""
echo "This applies a patch that adds console.log statements to show:"
echo "- Which projects are included in the projectNodes array"
echo "- Which projects actually have version data"
echo "- That dependents are being processed even though they won't get changelogs"
echo ""

# Apply the logging patch
patch -p1 < patches/add-logging.patch

echo "Running: npx nx release changelog utils --verbose --dry-run"
echo ""

npx nx release changelog utils --verbose --dry-run

# Restore original
patch -R -p1 < patches/add-logging.patch
