#!/bin/bash

GREEN='\033[0;32m' 
LGREEN='\033[1;32m' 
WHITE='\033[1;37m'
YELL='\033[1;33m'
RED='\033[0;31m'
LRED='\033[1;31m'
MAG='\033[0;35m'
LMAG='\033[1;35m'
CYAN='\033[0;36m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color



#default :
freq=60



opt_short="hf:"
opt_long="help,freq:"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

if [ $? -ne 0 ] ; then
        echo "Wrong input parameter!"; 1>&2
        exit 1;
fi

eval set -- "$OPTS"

while true
do
    case "$1" in
        -h|--help)    echo "User help"; exit 0;;        
        -v|--verbose) echo VERBOSE=1; shift;;     
        -f|--freq)
            [[ ! "$2" =~ ^- ]] && freq=$2
            shift 2 ;;  
        --) # End of input reading
            shift; break ;;
    esac
done

if [ -f "$FILE" ] ; then
    echo "File '$FILE' doesn't exist!" 1>&2
    exit 1
fi


printf "Freq sec : ${YELL}'$freq'${NC}\n"

 
#cache dir: 
cachedir=$HOME/.cache/streamjpeg

# printf "Changing to webserver directory : ${WHITE}'$path'${NC}\n"
# cd "$path"

# while true; do
#   printf "${YELL}Cleaning some files${NC}\n"
#   sleep $freq_sec
#   kill $!
# done
