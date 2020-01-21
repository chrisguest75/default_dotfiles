#!/usr/bin/env bash

if command -v shellcheck; then
    find ./* -iname "*.sh" -type f -exec shellcheck {} \;
else
    echo "shellcheck is not installed"
fi