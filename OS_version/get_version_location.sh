############################################################################# 
# This version of the script works only inside my env as this has few toold #
# dependencies to find the location of the device.                          #
#                                                                           #   
# Please do not use this as this wont work for you.                         #
#############################################################################

#!/bin/bash

# Prompt user for the username
read -p "Enter username: " username

# Prompt user for the password
read -sp "Enter password: " password

echo ""

# Path to file containing IP addresses, change as needed
devices="switches.txt"

# Output file names
output_txt_file="/homes/nithinj/data/switch_version.txt"
output_csv_file="/homes/nithinj/data/switch_version.csv"

# Clear the output files before running the script
> "$output_txt_file"
> "$output_csv_file"
echo -e "Hostname,Model,Junos,Kernel,Rack,Elevation" >> "$output_csv_file"

# Loop over each IP address in the file
while read -r ip_address
do
    # Test if the device is reachable
    if ping -c 1 "$ip_address" &> /dev/null
    then
        # Connect to the switch via telnet and execute the show version command
        {
            echo "$username"
            sleep 1
            echo "$password"
            sleep 2
            echo "cli"
            sleep 1
            echo "show version detail | no-more"
            sleep 2
            echo "exit"
            sleep 1
        } | telnet "$ip_address"  > /tmp/show_version.txt 2>&1

        # Extract hostname, model, and Junos version from the temporary file
        hostname=$(grep Hostname /tmp/show_version.txt | awk '{print $2}' | tr -d '[:space:]')
        model=$(grep Model /tmp/show_version.txt | awk '{print $2}' | tr -d '[:space:]')
        junos=$(grep Junos /tmp/show_version.txt | awk '{print $2}' | tr -d '[:space:]')
        kernel=$(grep KERNEL /tmp/show_version.txt | awk '{print $2}' | tr -d '[:space:]')

	# Fetch location of the device (wtfi is another script)	
	wtfi $ip_address > /tmp/location.txt
        sleep 2
        
	# Extract rack and elevation of the device from the temp location file
	rack=$(grep $ip_address /tmp/location.txt | awk '{print $6}' | tr -d '[:space:]')
	elevation=$(grep $ip_address /tmp/location.txt | awk '{print $7}' | tr -d '[:space:]')

        # Write the output to the text file
        echo "Hostname: $hostname" >> "$output_txt_file"
        echo "Model: $model" >> "$output_txt_file"
        echo "Junos: $junos" >> "$output_txt_file"
        echo "Kernel: $kernel" >> "$output_txt_file"
	echo "Rack: $rack" >> "$output_txt_file"
	echo "Elevation: $elevation" >> "$output_txt_file"
	
	# Write the output to the CSV file
	echo -e "$hostname,$model,$junos,$kernel,$rack,$elevation" >> "$output_csv_file"
        
	# Add a line to differentiate the next switch data in the output file
        echo "-----------------------------------------------------" >> "$output_txt_file"

        # Print a message indicating that the output has been saved
        echo "Output of $ip_address saved to $output_txt_file and $output_csv_file"
    else
        # Display message indicating that the device could not be reached
        echo "Device $ip_address is not reachable"
    fi

done < "$devices"

# Remove the temporary file
rm /tmp/show_version.txt
rm /tmp/location.txt
