#!/bin/bash
# -------------------------------
#       deploy
#
#       a script to make deploying Wolke just a bit easier
#       requires: root access, podman and git
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
echo "[${green}${bold}OK${reset}] Services configured!"
echo

echo "Now Im going to create the wolke pod, http network and build both services"
echo

sudo podman network create http > /dev/null

echo "[${green}${bold}OK${reset}] Created the http network"

sudo podman network create http > /dev/null

echo "[${green}${bold}OK${reset}] Created the wolke pod"

sudo podman pod create --name wolke --network http > /dev/null
echo

cd api 
sudo podman build -t wolke_api:latest .

echo
echo "[${green}${bold}OK${reset}] Built the API!"
echo

cd ..

cd bot 
sudo podman build -t wolke_bot:latest .

echo
echo "[${green}${bold}OK${reset}] Built the bot!"

echo "[${green}${bold}OK${reset}] Both services built, http network and wolke pod created!"
echo

cd ..

read -p "The services require the database be up, should I start it? (Y/n) " -n 1 -r

echo  
if [[ $REPLY =~ ^[Nn]$ ]]
then
        echo
        echo "Not starting database, you can start it with"
        echo "'sudo podman run --name wolke_postgres --pod wolke --rm -e POSTGRES_DB=wolke -e POSTGRES_PASSWORD=postgres -v $(pwd)/postgresql_data:/var/lib/postgresql/data:z docker.io/postgres:13-alpine'"
        exit 0
fi

mkdir postgresql_data

sudo podman run --name wolke_postgres --pod wolke --rm -d -e POSTGRES_DB=wolke -e POSTGRES_PASSWORD=postgres -v $(pwd)/postgresql_data:/var/lib/postgresql/data:z docker.io/postgres:13-alpine > /dev/null

echo
echo "[${green}${bold}OK${reset}] Database (wolke_postgres) started!"

read -p "Should I start the services now? (Y/n) " -n 1 -r

echo  
if [[ $REPLY =~ ^[Nn]$ ]]
then
        echo
        echo "Not starting services! You can start them with"
        echo "API: 'sudo podman run --name wolke_api --rm --network http --pod wolke -d wolke_api:latest'"
        echo "Bot: 'sudo podman run --name wolke_bot --rm --network http --pod wolke -d wolke_bot:latest'"
        exit 0
fi

sudo podman run --name wolke_api --rm --pod wolke -d wolke_api:latest > /dev/null
sudo podman run --name wolke_bot --rm --pod wolke -d wolke_bot:latest  > /dev/null

echo
echo "[${green}${bold}OK${reset}] Started the API (wolke_api) and bot (wolke_bot)!"
echo 

api_ip=$(sudo podman inspect --format '{{ .NetworkSettings.Networks.http.IPAddress }}' wolke_api)

echo "The API is now available at http://${api_ip}:PORT"
echo "Stop the pod with 'sudo podman pod stop wolke'"
echo "Remove the pod with 'sudo podman pod rm wolke'"
