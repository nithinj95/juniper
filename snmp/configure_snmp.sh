#!/bin/bash

# credentials to login
ssh_user="username"
ssh_password="password"

# Devices to configure
switch_ip="switch_ip_address"

# ssh command to execute config on the switch
ssh_command="sshpass -p $ssh_password ssh $ssh_user@$switch_ip"

# Function to execute a command on the switch via SSH
function execute_command() {
    command=$1
    $ssh_command "$command"
}

# Juniper commands to confiugre SNMP
execute_command "cli"
execute_command "confiugre"
execute_command "set snmp community $community_string authorization read-only"
execute_command "commit"

echo "SNMP configuration on $switch_ip completed successfully."