#!/bin/bash

echo "Choose inbound to update:"
echo "1) VLESS Reality Steal Oneself"
echo "2) VLESS WS"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
    read -p "Node domain (e.g., example.com): " address_domain
elif [ "$choice" == "2" ]; then
    read -p "Node domain (e.g., cdn.example.com): " address_domain
else
    echo "Invalid choice! Please select 1 or 2."
    exit 1
fi

if [ "$choice" == "1" ]; then
    read -p "Main domain: " sni_domain
fi

read -p "MySQL password: " MySQL_password

if [ "$choice" == "2" ]; then
    read -p "Path (e.g., /2bMC3f7wFbafrCi): " user_path
    full_path="${user_path}?ed=2560"
fi

container_id=$(docker ps -q -f ancestor=mariadb:lts)

if [ -z "$container_id" ]; then
    echo "Container with image mariadb:lts not found or not running."
    exit 1
fi

if [ "$choice" == "1" ]; then
    docker exec -it $container_id mariadb --default-character-set=utf8mb4 -u marzban -p${MySQL_password} marzban -e "
    UPDATE hosts 
    SET 
        remark = '🇷🇺 Быстрый 🚀',
        address = '${address_domain}',
        port = 443,
        sni = '${sni_domain}',
        fingerprint = 'chrome'
    WHERE 
        inbound_tag = 'VLESS Reality Steal Oneself';
    "
elif [ "$choice" == "2" ]; then
    docker exec -it $container_id mariadb --default-character-set=utf8mb4 -u marzban -p${MySQL_password} marzban -e "
    UPDATE hosts 
    SET 
        remark = '🇷🇺 Устойчивый 🛡️',
        address = '${address_domain}',
        port = 8443,
        sni = '${address_domain}',
        host = '${address_domain}',
        security = 'tls',
        fingerprint = 'chrome',
        path = '${full_path}'
    WHERE 
        inbound_tag = 'VLESS WS';
    "
fi

if [ $? -eq 0 ]; then
    echo "Update is done."
else
    echo "Error occurred during update. Check database logs for details."
    exit 1
fi

marzban restart
