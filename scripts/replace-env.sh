#!/bin/bash
active_color=$1
target_file=$2
tem_path="../nginx/conf.d.tem/$target_file"
docker_conf_path="../nginx/conf.d/$target_file"

echo "$active_color"

if [ "$active_color" == "blue" ]; then
    switch_color="green"
else
    switch_color="blue"
fi

conf=$(sed "s|\$active_color|$switch_color|g" "$tem_path")

echo "$conf" > "$docker_conf_path"
