#!/bin/bash

#install stuff
what=${PWD##*/}   
extension=.sh
#peut être extension vide 
 
echo "killing running instances"
killall $what

echo "remove symbolic link from usr bin"
sudo rm /usr/bin/$what


cachedir=$HOME/.cache/streamjpeg
echo "remove installed server path [$cachedir]"
rm -rf "$cachedir"


echo "done."

