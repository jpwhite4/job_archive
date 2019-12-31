#!/bin/bash

set -e

TESTDIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SRCDIR=$TESTDIR/..

INPUT_PREFIX=/tmp/spool/slurm
INPUT_DIR=${INPUT_PREFIX}/hash.
OUTPUT_DIR=/tmp/output

rm -rf /tmp/spool/slurm

for ((i=0; i < 10; i++));
do
    mkdir -p ${INPUT_DIR}$i
done

mkdir -p $OUTPUT_DIR

make -C $SRCDIR
