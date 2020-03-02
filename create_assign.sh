#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ $# -ne 1 ]; then
  echo "Usage: $0 ASSIGNMENT"
  exit 2
fi

cd $SCRIPTPATH

if [ ! -f netids ]; then
  echo "Please create a netids file with all students' netids"
  exit 1
fi

mkdir -p "input/$1"
for user in $(cat netids); do
  mkdir -p "submits/$1/$user"
done

echo "Make sure to populate \"$SCRIPTPATH/input/$1\" with your input cases!"
echo "  .in = input files, .correct = correct output (if any)"
