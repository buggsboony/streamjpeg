#!/bin/bash
kate &
pid1=$!
echo "started proc1: ${pid1}"

kcalc &
pid2=$!
echo "started proc2: ${pid2}"

echo -n "working..."
#trap "kill -2 $pid1 $pid2" SIGINT
trap "kill -9 $pid1 $pid2" SIGINT

echo "Waiting for processes"
wait $pid1 $pid2
echo " done"