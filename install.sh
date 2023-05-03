#!/bin/bash

#install stuff
what=${PWD##*/}   
extension=.sh

echo "Rendre exécutable..."
chmod +x $what$extension
echo "lien symbolique vers usr bin"
sudo ln -s "$PWD/$what$extension" /usr/bin/$what


