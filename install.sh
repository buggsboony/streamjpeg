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

 

#install stuff
what=${PWD##*/}   
extension=.sh

echo "Rendre exécutable..."
chmod +x $what$extension
echo "lien symbolique vers usr bin"
sudo ln -s "$PWD/$what$extension" /usr/bin/$what

#Create Default website path : 
cachedir=$HOME/.cache/streamjpeg
if [ ! -d $cachedir ];
then
    mkdir -p $cachedir       
    if [ ! -d $cachedir ];
    then 
        printf "Cache directory ${LRED}'$cachedir'${NC} does not exist.${NC}\n";
    else
        printf "Cache directory ${YELL}'$cachedir'${NC} created.\n";
    fi
fi

printf "sending web files to $cachedir.\n";
        printf "${YELL}\n";

cp -v ./index.php "$cachedir/"
cp -v ./index_static.html "$cachedir/"
cp -v ./cleaner.php "$cachedir/"

        printf "${NC}\n";