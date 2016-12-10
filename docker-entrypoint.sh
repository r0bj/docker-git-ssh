#!/bin/sh

if [ -z "$SSH_USER" ]; then
    SSH_USER="git"
fi

if [ -n "$SSH_UID" ]; then
    OPTS="$OPTS -u $SSH_UID"
fi

if [ -n "$SSH_GID" ]; then
    OPTS="$OPTS -G $SSH_USER"
    addgroup -g $SSH_GID $SSH_USER
fi

adduser -D -s /bin/bash $OPTS $SSH_USER $SSH_USER
# set some password to make accound unlocked for sshd
# PasswordAuthentication is disabled in sshd 
pass=$(echo fubar | mkpasswd)
echo "$SSH_USER:${pass}" | chpasswd

if [ -d "/home/$SSH_USER/.ssh" ]; then
    chown -R $(id -u $SSH_USER):$(id -g $SSH_USER) /home/$SSH_USER/.ssh
    chmod 0700 /home/$SSH_USER/.ssh
fi

if [ -d "/home/$SSH_USER/.ssh/authorized_keys" ]; then
    chown -R $(id -u $SSH_USER):$(id -g $SSH_USER) /home/$SSH_USER/.ssh/authorized_keys
    chmod 0600 /home/$SSH_USER/.ssh/authorized_keys
fi

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
	mkdir -p /var/run/sshd
fi

exec "$@"
