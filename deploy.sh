#!/bin/bash
# -------------------------------
#       deploy
#
#       a script to make deploying Wolke just a bit easier
#       requires: podman, root access and git
# -------------------------------

red=$(tput setaf 1)
green=$(tput setaf 2)
bold=$(tput bold)
reset=$(tput sgr0)
pwd=$(pwd)

if [ "$EUID" -ne 0 ]
    then echo "This script requires root."
    exit
fi

if ! [ -x "$(command -v podman)" ]; then
    echo "[${red}${bold}ERR${reset}] Podman must be installed for this script.."
    exit 
else
    echo "[${green}${bold}OK${reset}] Podman installed!"
fi

if ! [ -x "$(command -v git)" ]; then
    echo "[${red}${bold}ERR${reset}] Git must be installed for this script.."
    exit 
else
    echo "[${green}${bold}OK${reset}] Git installed!"
fi

echo 
echo "Welcome to the deploy script for Wolke.."
echo
echo "${red}${bold}If you havent please review the source so you are aware of what I'm going to do!${reset}"

echo

read -p "Continue? (Y/n) " -n 1 -r

echo  
if [[ $REPLY =~ ^[Nn]$ ]]
then
        echo
        echo "Quitting!"
        exit 0
fi

if [ ! -d "api/" ]
then   
    echo "[${red}${bold}ERR${reset}] API directory doesn't exist, cloning it."
    git clone --quiet https://github.com/wolke-casa/api.git
    echo "[${green}${bold}OK${reset}] Cloned the API"
    cd api && mv .env.example .env && cd ..
fi

if [ ! -d "bot/" ]
then   
    echo "[${red}${bold}ERR${reset}] Bot directory doesn't exist, cloning it."
    git clone --quiet https://github.com/wolke-casa/bot.git
    echo "[${green}${bold}OK${reset}] Cloned the Bot"
    cd bot && mv .env.example .env && cd ..
fi

echo
echo "[${green}${bold}OK${reset}] API and bot directories found!"
echo

read -p "Did you already configure the services via the ${bold}.env${reset} file? (Y/n) " -n 1 -r

echo  
if [[ $REPLY =~ ^[Nn]$ ]]
then
        echo
        echo "Please configure these files in the service directories and re-run this script."
        exit 0
fi

echo
echo "Good!"
echo

