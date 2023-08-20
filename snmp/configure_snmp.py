from netmiko import ConnectHandler
import getpass

# Read IP addresses from the file
with open('switch_ips.txt') as f:
    switch_ips = f.read().splitlines()

# Prompt for username and password
username = input("Enter your username: ")
password = getpass.getpass("Enter your password: ")

# Replace this with your desired community string
community_string = 'public'

# Loop through switch IPs
for switch_ip in switch_ips:
    device_params = {
        'device_type': 'juniper_junos',
        'ip': switch_ip,
        'username': username,
        'password': password,
    }

    ssh_session = ConnectHandler(**device_params)

    # Configure SNMP
    config_commands = [
        f'set snmp community {community_string} authorization read-only',
        'commit',
    ]

    output = ssh_session.send_config_set(config_commands)
    print(output)

    ssh_session.disconnect()
