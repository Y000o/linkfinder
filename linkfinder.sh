#!/bin/bash

intro () {
clear

echo -e "======================================="
echo -e "  _ _      _   ___ _         _"
echo -e " | (_)_ _ | |_| __(_)_ _  __| |___ _ _ "
echo -e " | | | ' \| / / _|| | ' \/ _• / -_) •_|"
echo -e " |_|_|_||_|_\_\_| |_|_||_\__,_\___|_|  "
echo -e
echo -e " simple link stractor"
echo -e
echo -e "                               _Y000!_"
echo -e "======================================"
echo -e
echo -e

}

intro
read -p "Ingresa un host: " HOST

host=($HOST)

for hosts in "{host[@]}"
do
        curl --silent --insecure "https://sonar.omnisint.io/subdomains/$HOST" > 1.txt && cat 1.txt | grep -oE "[a-zA-Z0-9._-]+\.$HOST" | sort -u > 2.txt && xargs -n 1 curl -0 < 2.txt | grep -Eio "(ft|htt)p(s)?://[^  \"]*" | sort | uniq > fin.txt && intro && cat fin.txt

done
