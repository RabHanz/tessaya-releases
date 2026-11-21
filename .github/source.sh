#!/usr/bin/env bash
# source.sh <ref> [paths...]: the private source at <ref> into ./src by its read-only deploy key (env KEY);
# with paths, only those (sparse). Not actions/checkout: its submodule cleanup fails on the source's vendored gitlinks.
set -euo pipefail
ref="$1"; shift
k="$(mktemp)"; trap 'rm -f "$k"' EXIT
printf '%s\n' "$KEY" > "$k"; chmod 600 "$k"
export GIT_SSH_COMMAND="ssh -i $k -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
git init -q src
if [ $# -gt 0 ]; then git -C src sparse-checkout set --no-cone "$@"; fi
host=github.com
git -C src fetch -q --depth 1 "git@$host:RabHanz/tessaya.git" "$ref"
git -C src -c advice.detachedHead=false checkout -q FETCH_HEAD
echo "source: pass"
