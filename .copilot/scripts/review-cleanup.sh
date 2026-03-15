#!/bin/bash
# review-cleanup.sh
# Runs on Stop — cleans up temporary review files

rm -f /tmp/review_diff.patch
rm -f /tmp/review_diff_frontend.patch
rm -f /tmp/review_diff_staged.patch
rm -f /tmp/review_diff_branch.patch
rm -f /tmp/review_meta.json
rm -f /tmp/review_files.txt
rm -f /tmp/review_partial_*.md

echo '{"continue":true}'
