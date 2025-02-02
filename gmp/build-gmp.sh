#!/usr/bin/env bash

set -euxo pipefail

echo building

echo '"$@:" ' "$@"
echo '$@: ' $@

sleep 5

mkdir -p $(dirname "$1")
cat tmp-gmp.h > "$1"

rm -f empty.o libempty.a
cc -c empty.s
ar rs libempty.a empty.o
rm -f empty.o

mv libempty.a "$2"
