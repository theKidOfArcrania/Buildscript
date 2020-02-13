#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ $# -ne 1 ]; then
  echo "Usage: $0 ASSIGNMENT"
  exit 2
fi

for name in $(cat netids); do
  sudo "$SCRIPTPATH/grade.sh" "$1" "$name"
done

