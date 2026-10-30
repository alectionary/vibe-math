#!/bin/sh
set -eu
cd "$(dirname "$0")"
LEAN=${LEAN:-lean}
"$LEAN" --version
"$LEAN" -o Hadamard.olean Hadamard.lean
"$LEAN" -o CyclicKernel.olean CyclicKernel.lean
LEAN_PATH=. "$LEAN" SourceBridge.lean
LEAN_PATH=. "$LEAN" -o CubicIncidence.olean CubicIncidence.lean
