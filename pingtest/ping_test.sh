#!/bin/bash

# Define the path to the text file containing the list of devices
devices_file="path to devices_file"

# Define the path to the file where the list of pingable devices will be stored
pingable_devices="change the path"

# Define the path to the file where the list of non-pingable devices will be stored
non_pingable_devices="change the path"

# Read the list of devices from the text file
devices=($(cat "$devices_file"))

# Loop through each device and ping it
for device in "${devices[@]}"
do
    ping -c 1 "$device" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$device is up"
        echo "$device" >> "$pingable_file"
    else
        echo "$device is down"
        echo "$device" >> "$non_pingable_file"
    fi
done