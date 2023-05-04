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


help=  'streamjpeg -r 1(rate) -p /path_to_website -i /path_video -P 8082 -s 1280x720 -X positionX -Y positionY  \n  '

#cache dir: 
cachedir=$HOME/.cache/streamjpeg

port=8082
path=$cachedir
rate=1 # rate=1 is normal readrate
#video_size=1024x768 #video_size non specifié par défaut = 
video_size_str=""
X=0
Y=0


while getopts ":p:i:P:a:s:x:y:r:" opt; do
  case $opt in
    a) width_height="$OPTARG"
    ;;
    P) port="$OPTARG"
    ;;   
    x) X="$OPTARG"
    ;;   
    y) Y="$OPTARG"
    ;;  
    s) video_size="$OPTARG"
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
    echo $help
    exit 1
    ;;
  esac
done


pattern="art"
ip_addr_port=0.0.0.0:$port





#Usage
#       streamjpeg -s /path_to_website
#ffmpeg -y -readrate 0.1 -stream_loop -1 -i /home/somevid.mp4 -f image2 -update 1 /home/serverpath/art.jpeg

if [ -z  "$video_size" ] ; then 
video_size_str=""
else
video_size_str=" -video_size $video_size"
fi


printf "${WHITE}Changing to webserver directory : ${YELL}'$path'${NC}\n"
cd "$path"

# cleaning folder 2023-05-04 16:49:29
printf "${WHITE}Removing images ${NC}${YELL}'$pattern*'${NC}\n"
rm $pattern*


printf "${WHITE}Starting php development server :${NC} ${YELL}'$ip_addr_port'${NC}\n"
php -S $ip_addr_port  &
pid_php=$!
printf "${WHITE}pid_php :${NC} ${LMAG}'$pid_php'${NC}\n"


printf "${WHITE}Start streaming with ffmpeg :${NC} ${YELL}'$ip_addr_port'${NC}\n"
if [ -z  "$video" ] ; then 
#Streaming cast screen -------
printf "${WHITE}Streaming :${NC} [${YELL} x11grab -i :0.0+$X,$Y  video_size_str=$video_size_st
  Stream #0:0: Video: rawvideo (BGR[0] / 0x524742), bgr0, 1920x1080, 1988667 kb/s, 29.97 fps, 1000k tbr, 1000k tbn
Stream mapping:
r ${NC}]\n"
#echo "x11grab -i :0.0+100,200"

extension=".jpeg"
pattern_file=$pattern'%1d'$extension


#ffmpeg -y $video_size_str -readrate $rate -draw_mouse 1 -stream_loop -1 -f x11grab -i :0.0+$X,$Y  -update 1 art.jpeg
ffmpeg -y $video_size_str -readrate $rate -draw_mouse 1 -stream_loop -1 -f x11grab -i :0.0+$X,$Y -vsync 0 "$path/$pattern_file"

else
#Streaming from video file -------------
printf "${WHITE}Streaming :${NC} ${YELL}'$video'${NC}\n"

extension=".png"
pattern_file=$pattern'%1d'$extension

ffmpeg -y -readrate $rate -stream_loop -1 -i $video -f image2 "$path/$pattern_file"
fi
pid_ffmpeg=$!
printf "${WHITE}pid_ffmpeg :${NC} ${LMAG}'$pid_ffmpeg'${NC}\n"

#Ready to kill all child processes on interrupt
trap "kill -9 $pid_php $pid_ffmpeg" SIGINT
echo "Waiting for processes"
wait $pid_php $pid_ffmpeg
echo " done"