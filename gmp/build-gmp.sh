#!/usr/bin/env bash

set -euxo pipefail

echo '"$@:" ' "$@"
echo '$@: ' $@

mkdir -p $(dirname "$1")
echo "'h', 'i', '\0'" > "$1"

rm -f empty.o libempty.a
cc -c empty.s
ar rs libempty.a empty.o
rm -f empty.o

mv libempty.a "$2"
