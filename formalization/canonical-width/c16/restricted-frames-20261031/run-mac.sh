#!/bin/bash
# Run the C16 half-turn cube-and-conquer on this Mac, one Kissat per core.
# Usage (from the unpacked folder):  ./run-mac.sh [jobs]     Stop with Ctrl-C; rerun to resume.
set -e
cd "$(dirname "$0")"
JOBS=${1:-$(( $(sysctl -n hw.ncpu) - 2 ))}
if [ ! -x src/kissat/build/kissat ]; then (cd src/kissat && ./configure && make -j"$JOBS"); fi
if [ ! -x src/drat-trim/drat-trim ]; then (cd src/drat-trim && make); fi
cd c16/restricted-frames-20261031
echo "Running $JOBS parallel jobs; log in $(pwd)/work/cnc/mac.log"
caffeinate -i python3 cnc_parallel.py --kissat ../../src/kissat/build/kissat \
  --drat-trim ../../src/drat-trim/drat-trim --jobs "$JOBS" --mode "${MODE:-search}" "${@:2}" 2>&1 | tee -a work/cnc/mac.log
