#!/bin/bash



read -p "Ingresa un host: " HOST

host=($HOST)

for hosts in "{host[@]}"
do
        curl --silent --insecure "https://sonar.omnisint.io/subdomains/$HOST" > 1.txt && cat 1.txt | grep -oE "[a-zA-Z0-9._-]+\.$HOST" | sort -u > 2.txt && xargs -n 1 curl -0 < 2.txt | grep -Eio "(ft|htt)p(s)?://[^  \"]*" | sort | uniq > fin.txt && cat fin.txt
        
done
