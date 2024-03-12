# Use the official image as a parent image
FROM ubuntu
ARG pass

# Update the system, install OpenSSH Server, and set up users
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openssh-server curl git

# Create user and set password for user and root user
RUN  useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu && \
    echo "ubuntu:$pass" | chpasswd && \
    echo "root:$pass" | chpasswd
# Set up configuration for SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN mkdir /root/.config
RUN mkdir /root/.config/code-server

COPY config.yaml /root/.config/code-server/

COPY init.sh /root
RUN chmod +x /root/init.sh

# Run SSH and code-server
CMD /bin/bash -c "/root/init.sh"
