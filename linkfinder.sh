#!/bin/bash
# Nse-nmap v1.1
# Author: _Y000!_




if [ "$(whereis nmap)" == "" ]; then
        echo -n -e "nmap será instalado... [y/N] "
        read -r nmap
        if [ "$nmap" == "y" ] || [ "$nmap" == "Y" ]; then
                apt install nmap
        elif [ "$nmap" == "n" ] || [ "$nmap" == "N" ]; then
                exit
        else
                apt install nmap
        fi

fi


intro () {
clear

echo -e "==============================================="
echo -e "     _ _      _   ___ _         _              "
echo -e "    | (_)_ _ | |_| __(_)_ _  __| |___ _ _      "
echo -e "    | | | ' \| / / _|| | ' \/ _• / -_) •_|     "
echo -e "    |_|_|_||_|_\_\_| |_|_||_\__,_\___|_|  v1.1 "
echo -e
echo -e "    simple link extractor                      "
echo -e
echo -e "                                    _Y000!_    "
echo -e "==============================================="
echo -e
echo -e

}


host_para_subdominios () {

clear
read -p "Ingresa un host: " HOST

host=($HOST)
numero_subdominios=$(cat 2.txt | wc -l)

for hosts in "{host[@]}"
do
        curl --silent --insecure "https://sonar.omnisint.io/subdomains/$HOST" > 1.txt

        cat 1.txt | grep -oE "[a-zA-Z0-9._-]+\.$HOST" | sort -u > 2.txt

        echo "Se encontraro: $numero_subdominios subdominios"

done
}


ip_subdominios () {
subdominios=$(cat 2.txt)

read -p "quieres la ip de los subdominios?: Y / N ?" ips
if [ "$ips" == "y" ] || [ "$ips" == "Y" ]
        then
        dig -f 2.txt +noall +answer > ips.txt
        cat ips.txt

        elif
        [ "$ips" == "n" ] || [ "$ips" == "N" ]
        then
        menu
fi
}


menu () {

intro

echo -e "Usted eligió la página: $host"
echo -e "Fueron encontrados: $numero_subdominios subdominios"

echo -e
echo -e "-------------------------------------------------------------------"
echo -e
echo -e
echo -e " [01] Mostrar listado de subdominios"
echo -e " [02] Mostrar IPs de subdominios"
echo -e " [03] Buscar links en los subdominios (puede tardar mucho...)"
echo -e " [04] Filtrar subdominios y hacer Banner Grabbing a los top 10 puertos"
echo -e " [0] Salir"
echo -e
echo -n -e  "linkfinder > "
read -r linkfinder
if [ "$linkfinder" == "1" ] || [ "$linkfinder" == "01" ]
        then
        cat 2.txt
        read -rsp $'Presiona alguna tecla para continuar...' -n 1 key
        menu

        elif
        [ "$linkfinder" == "2" ] || [ "$linkfinder" == "02" ]
        then
        ip_subdominios
        read -rsp $'Presiona alguna tecla para continuar...' -n 1 key
        menu

        elif
        [ "$linkfinder" == "3" ] || [ "$linkfinder" == "03" ]
        then
        xargs -n 1 curl -0 < 2.txt | grep -Eio "(ft|htt)p(s)?://[^  \"]*" | sort
        read -rsp $'Presiona alguna tecla para continuar...' -n 1 key
        menu

        elif
        [ "$linkfinder" == "4" ] || [ "$linkfinder" == "04"]
        then
        banner
        read -rsp $'Presiona alguna tecla para continuar...' -n 1 key
        menu


        elif
        [ "$linkfinder" == "00" ] || [ "$linkfinder" == "0" ];
        then
        salir
fi
}

banner () {

echo "Para proceder con el Banner Grabbing primero vamos a filtrar los subdominios"

cat 2.txt | grep -Eoi '(ftp|www|endpoint).[a-zA-Z0-9._-]*' > top.txt

# escaneo con nmap

nmap -iL top.txt --top-ports 10 -T4 -sV --script=banner -oG bann.txt

# mostrar resultado

cat bann.txt | awk '/open/{print $1 $2 "\n\n" $4 "\n" $5 "\n" $6 "\n" $10 "\n" $11 "\n" $12 "\n" $14 "\n" $16 "\n" $17 "\n" $19 "\n" $20 "\n\n"}'

}



mostrar_subdominios () {

echo "Los subdominios son: "
cat 2.txt
}


salir () {

echo -e "Gracias por usar mi herramienta....."
exit

}
host_para_subdominios

menu
