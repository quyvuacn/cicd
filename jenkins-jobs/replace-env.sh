#!/bin/bash
curent_color=$1
target_file=$2
tem_path="./conf.d.tem/$target_file"
docker_conf_path="etc/nginx/conf.d/$target_file"

if [ "$curent_color" == "blue" ]; then
    switch_color="green"
else
    switch_color="blue"
fi

conf=$(sed "s|\$curent_color|$switch_color|g" "$tem_path")

container_id=$(docker ps -qf "name=nginx")
echo "$conf" | docker exec -i "$container_id" bash -c "cat > $docker_conf_path"

docker exec -i "$container_id" nginx -s reload