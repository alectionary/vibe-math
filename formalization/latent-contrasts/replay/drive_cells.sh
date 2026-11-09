#!/bin/bash
# Run the 36 Jeffries cells at full size, committing and pushing each one.
# Skips a cell whose csv.gz is already present. Does not change allocations,
# replicate counts, or the engine. Stops before a cell that would put
# results/replay over 100 MB.
set -euo pipefail

ROOT=/agent/repos/vibe-math
STUDY="$ROOT/formalization/latent-contrasts"
OUT="$STUDY/results/replay"
WORK=/tmp/jeffries-work
LOG=/tmp/jeffries-driver.log
NCORES=$(nproc)
LIMIT=$((100 * 1024 * 1024))

export PATH="$HOME/R-4.2.2/bin:$PATH"
export R_LIBS_USER="$HOME/R-lib"
export OMP_NUM_THREADS=1

mkdir -p "$OUT" "$WORK"
cd "$ROOT"

CELLS=(
  "mgcfa true 240 1"
  "mgcfa true 240 2"
  "mgcfa true 240 3"
  "mgcfa null 240 1"
  "mgcfa null 240 2"
  "mgcfa null 240 3"
  "mimic true 240 1"
  "mimic true 240 2"
  "mimic true 240 3"
  "mimic null 240 1"
  "mimic null 240 2"
  "mimic null 240 3"
  "mgcfa true 480 1"
  "mgcfa true 480 2"
  "mgcfa true 480 3"
  "mgcfa null 480 1"
  "mgcfa null 480 2"
  "mgcfa null 480 3"
  "mimic true 480 1"
  "mimic true 480 2"
  "mimic true 480 3"
  "mimic null 480 1"
  "mimic null 480 2"
  "mimic null 480 3"
  "mgcfa true 960 1"
  "mgcfa true 960 2"
  "mgcfa true 960 3"
  "mgcfa null 960 1"
  "mgcfa null 960 2"
  "mgcfa null 960 3"
  "mimic true 960 1"
  "mimic true 960 2"
  "mimic true 960 3"
  "mimic null 960 1"
  "mimic null 960 2"
  "mimic null 960 3"
)

TIMING="$OUT/timings.csv"
if [[ ! -f "$TIMING" ]]; then
  echo "cell,start_utc,end_utc,wall_seconds,rows,converged,bytes,status" > "$TIMING"
fi

push_retry() {
  local wait=4
  local attempt
  for attempt in 1 2 3 4 5; do
    if git push -u origin replication/jeffries-2024; then
      return 0
    fi
    echo "push failed attempt $attempt" | tee -a "$LOG"
    if [[ $attempt -eq 5 ]]; then
      return 1
    fi
    sleep "$wait"
    wait=$((wait * 2))
  done
}

bytes_of_dir() {
  du -sb "$OUT" | awk '{print $1}'
}

for spec in "${CELLS[@]}"; do
  read -r model pop N cond <<< "$spec"
  cell=$(printf "%s_%s_n%s_c%s" "$model" "$pop" "$N" "$cond")
  dest="$OUT/${cell}.csv.gz"
  if [[ -f "$dest" ]]; then
    echo "SKIP $cell" | tee -a "$LOG"
    continue
  fi
  have=$(bytes_of_dir)
  # One N=240 cell is the size reference; refuse to start a cell once the
  # directory is already within 8 MB of the 100 MB ceiling.
  if [[ $((have + 8 * 1024 * 1024)) -gt $LIMIT ]]; then
    echo "STOP size ${have} bytes is within 8 MB of 100 MB; not starting $cell" | tee -a "$LOG"
    exit 2
  fi
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  t0=$(date +%s)
  echo "START $cell $start cores=$NCORES" | tee -a "$LOG"
  set +e
  Rscript "$STUDY/replay/run_cell.R" "$model" "$pop" "$N" "$cond" "$OUT" "$WORK" "$NCORES" >> "$LOG" 2>&1
  rc=$?
  set -e
  t1=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  wall=$((t1 - t0))
  if [[ $rc -ne 0 || ! -f "$dest" ]]; then
    echo "$cell,$start,$end,$wall,0,0,0,fail" >> "$TIMING"
    echo "FAIL $cell rc=$rc wall=$wall" | tee -a "$LOG"
    git add -- "$TIMING"
    git commit -m "Jeffries: ${cell} failed (rc ${rc})

Paper: pending compute stage in progress"
    push_retry || echo "push of failure record failed" | tee -a "$LOG"
    exit 1
  fi
  bytes=$(stat -c%s "$dest")
  rows=$(($(gzip -dc "$dest" | wc -l) - 1))
  converged=$(gzip -dc "$dest" | awk -F, 'NR>1 && $2==1 {c++} END {print c+0}')
  total=$(bytes_of_dir)
  if [[ $total -gt $LIMIT ]]; then
    echo "STOP $cell would put results/replay at ${total} bytes, over 100 MB. File left uncommitted at $dest" | tee -a "$LOG"
    exit 2
  fi
  echo "$cell,$start,$end,$wall,$rows,$converged,$bytes,ok" >> "$TIMING"
  git add -- "$dest" "$TIMING"
  git commit -m "Jeffries: replay ${cell}

${rows} rows, ${converged} converged, ${wall}s wall, ${bytes} bytes.

Paper: pending compute stage in progress"
  echo "COMMITTED $cell wall=${wall}s bytes=${bytes} total=${total}" | tee -a "$LOG"
  push_retry
done

echo "ALL_CELLS_DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG"
