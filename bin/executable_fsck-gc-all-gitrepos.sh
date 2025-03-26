#!/usr/bin/env bash

set -eou pipefail

find ~+ -name .git -type d | while read gitdir
do
    echo "$gitdir"
    cd "$gitdir/.."
    git fsck --full
    git commit-graph verify
    git gc
    echo
done
