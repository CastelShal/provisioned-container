#!/bin/bash

# Process arguments using getopts
while getopts ":p:s:" opt; do
  case $opt in
    p) 
      # Check if argument is a number
      if [[ ! $OPTARG =~ ^[0-9]+$ ]]; then
        echo "Error: -p argument must be a number."
        exit 1
      fi
      port="$OPTARG"
      ;;
    s) 
      pass="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Check if both flags are present
if [[ -z "$port" || -z "$pass" ]]; then
  echo "Usage: $0 -p <port> -s <password>"
  exit 1
fi

# Script logic using retrieved values
echo "Port: $port"
echo "Password: $pass"

# Add your specific script logic here using $number_value and $string_value
docker build --build-arg pass=$pass -t cynosure .
docker run --network=labnet -d -p $port:22 cynosure

sudo ufw allow $port
#gitlab 172.19.0.3:8929
#penpot 172.19.0.2