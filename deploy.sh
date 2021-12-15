#!/bin/bash
# -------------------------------
#       deploy
#
#       a script to make deploying Wolke just a bit easier
#       requires: podman, root access and git
# -------------------------------

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

if [ "$EUID" -ne 0 ]
    then echo "This script requires root."
    exit
fi

if ! [ -x "$(command -v podman)" ]; then
    echo "[${red}ERR${reset}] Podman must be installed for this script.."
    exit 
else
    echo "[${green}OK${reset}] Podman installed!"
fi

if ! [ -x "$(command -v git)" ]; then
    echo "[${red}ERR${reset}] Git must be installed for this script.."
    exit 
else
    echo "[${green}OK${reset}] Git installed!"
fi

echo 
echo "Welcome to the deploy script for Wolke.."
echo "If you havent please review the source so you are aware of what I'm going to do!"

echo

read -p "Continue? (Y/n) " -n 1 -r

echo  
if [[ $REPLY =~ ^[Nn]$ ]]
then
        echo "Quitting!"
        exit 0
fi

echo
echo "I'll start by cloning the repos.."
echo

git clone --quiet https://github.com/wolke-casa/api.git
git clone --quiet https://github.com/wolke-casa/bot.git

echo "[${green}OK${reset}] Cloned!"
echo 