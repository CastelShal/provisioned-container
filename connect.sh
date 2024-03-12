#!/bin/bash
url=localhost
while getopts ":p:" opt; do
  case $opt in
    p) 
    if [[ ! $OPTARG =~ ^[0-9]+$ ]]; then
        echo "Error: -p argument must be a number."
        exit 1
      fi
      port="$OPTARG"
      ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Check if port is provided and validate
if [ -z "$port" ]; then
  echo "Error: Please provide a port number using -p flag."
  exit 1
fi

ssh-copy-id -p $port ubuntu@$url
clear
echo "Connected Successfully. Visit localhost:[8080|8929|9001]"
echo "To terminate this process, use Ctrl-C. Exiting otherwise will leave ports occupied"
ssh -N -L 8080:127.0.0.1:8080 -p $port ubuntu@$url &
ssh -N -L 8929:172.19.0.3:8929 -p $port ubuntu@$url &
ssh -N -L 9001:172.19.0.2:80 -p $port ubuntu@$url
kill $(jobs -p)  # Get PIDs of all background jobs and send SIGTERM
jobs

