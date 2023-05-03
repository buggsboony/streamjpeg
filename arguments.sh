#!/bin/bash


p_out="defaultvaluefor_p"
#USAGE :    ./arguments.sh -a 12 -p /home/boony  
while getopts ":a:p:h:" opt; do
  case $opt in
    a) arg_1="$OPTARG"
    ;;
    p) p_out="$OPTARG"
    ;;
    h) echo "-p path - $OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

printf "Argument p_out is %s\n" "$p_out"
printf "Argument arg_1 is %s\n" "$arg_1"