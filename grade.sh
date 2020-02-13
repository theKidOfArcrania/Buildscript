#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ $# -ne 2 ]; then
  echo "Usage: $0 ASSIGNMENT USERID"
  exit 2
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "*** Must be root ***"
  exit 2
fi

exec 2>&1

run_buildrunner() {
  cd "$SCRIPTPATH/runner"
  docker run --rm --security-opt seccomp=seccomp-rules.json -i buildrunner $1
}

send_input() {
  tar -h --group=root --owner=root -zc -C "$1" . | uuencode inp.tar.gz
}

extract_output() {
  cat "$UUE_OUT" | uudecode -o "$TAR_OUT"
  rm $UUE_OUT
  tar -xf $TAR_OUT -C $OUTPUT_DIR
  rm $TAR_OUT
}

action() {
  send_input "$1" | run_buildrunner $2 > $UUE_OUT
  local RES=$?
  extract_output || true
  return $RES
}

last_mod() {
  if ! stat -c %Y "$@" 2> /dev/null; then
    echo 0
  fi
}

DIR="$SCRIPTPATH/submits/$1/$2"
INPUT_DIR="$SCRIPTPATH/input/$1"
OUTPUT_DIR="$SCRIPTPATH/output/$1/$2"
PROG=$OUTPUT_DIR/prog

UUE_OUT=$OUTPUT_DIR/out.uue
TAR_OUT=$OUTPUT_DIR/out.tar.gz

echo "*********************"
echo "*** $1/$2"
echo "*********************"

if ! ls $DIR/* > /dev/null 2> /dev/null; then
  echo "[+] *** NO SUBMISSION! ***"
  exit 1
fi

SUB_MOD=$(last_mod $DIR/* | sort -nr | head -1)
OUP_BUILT=$(last_mod $OUTPUT_DIR/.build)
INP_MOD=$(last_mod $INPUT_DIR/* | sort -nr | head -1)
OUP_RUN=$(last_mod $OUTPUT_DIR/.run)

mkdir -p "$OUTPUT_DIR"
rm -f $OUTPUT_DIR/src $OUTPUT_DIR/input
ln -s $DIR $OUTPUT_DIR/src
ln -s $INPUT_DIR $OUTPUT_DIR/input

echo "[+] *** COMPILING ***"
if [ $SUB_MOD -le $OUP_BUILT ]; then
  echo "[+] *** ALREADY BUILT ***"
else
  if action "$DIR" build; then
    echo "[+] Compilation successful"
  else
    echo "[+] Compilation failed"
    cat $OUTPUT_DIR/compile_log || true
    touch $OUTPUT_DIR/.build
    exit 1
  fi
fi
touch $OUTPUT_DIR/.build

echo "[+] *** RUNNING ***"
if [ $OUP_BUILT -le $OUP_RUN -o $INP_MOD -le $OUP_RUN ]; then
  echo "[+] *** ALREADY RAN ALL TESTCASES ***"
else
  rm -f *.err *.out
  if action "$OUTPUT_DIR" run; then
    echo "[+] Run successful"
  else
    echo "[+] Run failed"
    exit 1
  fi
fi

touch $OUTPUT_DIR/.run
