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

 
#cache dir: 
cachedir=$HOME/.cache/streamjpeg

port=8080
path=$cachedir
rate=0.8 # rate=1 is normal readrate

while getopts ":p:i:P:" opt; do
  case $opt in
    a) arg_1="$OPTARG"
    ;;
    P) port="$OPTARG"
    ;;   
    p) path="$OPTARG"
    ;;
    r) rate="$OPTARG"
    ;;
    i) video="$OPTARG"
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


ip_addr_port=0.0.0.0:$port

#Usage
#       streamjpeg -s /path_to_website
#ffmpeg -y -readrate 0.1 -stream_loop -1 -i /home/somevid.mp4 -f image2 -update 1 /home/serverpath/art.jpeg




printf "Changing to webserver directory : ${WHITE}'$path'${NC}\n"
cd "$path"

printf "Starting php development server : ${YELL}'$ip_addr_port'${NC}\n"
php -S $ip_addr_port  &
pid_php=$!
printf "pid_php : ${LMAG}'$pid_php'${NC}\n"


printf "Start streaming with ffmpeg : ${YELL}'$ip_addr_port'${NC}\n"
if [ -z  "$video" ] ; then 
printf "Streaming : ${YELL}'X11grab'${NC}\n"
#echo "x11grab -i :0.0+100,200"
#ffmpeg -y -readrate $rate -stream_loop -1 -i $video -f image2 -update 1 $path/art.jpeg 
else
printf "Streaming : ${YELL}'$video'${NC}\n"
ffmpeg -y -readrate $rate -stream_loop -1 -i $video -f image2 -update 1 $path/art.jpeg
fi
pid_ffmpeg=$!
printf "pid_ffmpeg : ${LMAG}'$pid_ffmpeg'${NC}\n"

#Ready to kill all child processes on interrupt
trap "kill -9 $pid_php $pid_ffmpeg" SIGINT
echo "Waiting for processes"
wait $pid_php $pid_ffmpeg
echo " done"