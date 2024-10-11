#!/bin/bash
active_color=$1
tem_path="../conf.d.tem/fe.conf"
path="../conf.d/fe.conf"

echo "$active_color"

if [ "$active_color" == "blue" ]; then
    switch_color="green"
else
    switch_color="blue"
fi

conf=$(sed "s|\$current_color|$switch_color|g" "$tem_path")

echo "$conf" > "$path"
