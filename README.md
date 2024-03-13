# provisioned-container

This is a project that enables a server-client setup to allow clients to access isolated docker containers and programming tools like GitLab and Penpot from a server via secured SSH connections.

Ensure that the server and all the clients are on the same network.

## Server Setup
You will need a computer running Ubuntu or one of it's derivatives.
### Install the following prerequisites:
- Docker engine
- docker-compose
- ufw

### Pull the docker image from docker hub:
- `docker pull ubuntu`

### Setup the docker DNS to use Google nameservers
- Edit `/etc/docker/daemon.json`
- Uncomment the line that starts with "dns"
- Save and exit

### Optional:
- Install GitLab from [GitLab Docs](https://docs.gitlab.com/ee/install/docker.html#install-gitlab-using-docker-compose)
- Install Penpot from [Penpot Self Host](https://help.penpot.app/technical-guide/getting-started/#start-penpot)
- Setup GitLab using the provided `docker-compose.yml`
- `docker compose -d up .`
- Change the external url in the `docker-compose.yml` to the IP address of the `gitlab` container on the `labnet` network.
- Use the GitLab Rails console to change the root user password as mentioned [here](https://docs.gitlab.com/ee/security/reset_user_password.html#reset-the-root-password)

### Set up the docker network
- `docker network create --driver=bridge labnet`
- `docker network connect penpot_frontend`
- `docker network connect gitlab`

### Provision containers
Provision containers using the script `provision.sh`. This script takes two parameters, a port and a password. Ensure that the port is free and open to listen on, and is not one of the reserved ports (1 - 1023). The password can be any non-whitespace string. 

Build takes about 1 - 5 minutes on a decent network speed. Docker will use the cached layers from previous builds to speed up subsequent builds. 

## Client Setup

### Prerequisites:
- Linux
- BASH shell
- A copy of the `connect.sh` script from this repository.
- An SSH key (generated via ssh-keygen)

### Setup
- Change the url parameter in the `connect.sh` script to the domain name/static IP of the server.
- Use `ssh-keygen` or relevant alternative to generate an SSH private/public key.
- The script will automatically attempt to register your SSH key with the container.
- Run `chmod 755 connect.sh`
- Run `./connect.sh -p <port>` with the port used by the provisioning script
- Enter the password used by the provisioning script when prompted.

Congratulations! You have successfully connected to your remote container! 
Visit the following to access your provisioned resources:

| Syntax         | Description |
| :---:          |   :----:    |
| localhost:8080 | VSCode |
| localhost:8929 | GitLab |
| localhost:9001 | Penpot |

- Use `Ctrl-C` to exit the script to ensure that the occupied ports are freed once the connections are closed.


