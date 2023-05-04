#!/bin/bash
#USAGE :
#  ./long_args.sh --verbose -f /home/somefile.txt   
#   ./long_args.sh --help
#    ./long_args.sh  -f /home/somefile.txt    


opt_short="hvf:"
opt_long="help,verbose,file:"

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
        -f|--file)
            [[ ! "$2" =~ ^- ]] && FILE=$2
            shift 2 ;;
        --) # End of input reading
            shift; break ;;
    esac
done

if [ -f "$FILE" ] ; then
    echo "File '$FILE' doesn't exist!" 1>&2
    exit 1
fi

echo "Remaining options: $*"