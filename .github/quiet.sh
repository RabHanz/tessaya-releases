#!/usr/bin/env bash
# quiet.sh <label> <command...>: a build step whose output stays off this public log. Prints pass or fail only.
label="$1"; shift
log="$(mktemp)"
if "$@" > "$log" 2>&1; then echo "$label: pass"; rm -f "$log"; else code=$?; echo "$label: fail (exit $code)"; rm -f "$log"; exit "$code"; fi
