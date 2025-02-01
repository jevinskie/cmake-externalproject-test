#!/usr/bin/env bash

mkdir -p $(dirname $1)
echo "'h', 'i', '\0'" > $1
