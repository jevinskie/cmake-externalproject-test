#!/usr/bin/env bash

set -euxo pipefail

echo configuring

echo '"$@:" ' "$@"
echo '$@: ' $@

sleep 5

echo "'h', 'i', '\0'" > tmp-gmp.h
