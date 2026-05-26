#!/bin/bash

# Set the directory permissions (Owner: read/write/execute)
chmod 700 ~/.ssh

# Set the private key permissions (Owner: read/write)
chmod 600 ~/.ssh/id_*
chmod 600 ~/.ssh/*.pem 2>/dev/null
chmod 600 ~/.ssh/config 2>/dev/null

# Set the public key and authorized_keys permissions (Owner: read/write, Others: read)
chmod 644 ~/.ssh/*.pub
chmod 644 ~/.ssh/authorized_keys 2>/dev/null
chmod 644 ~/.ssh/known_hosts 2>/dev/null

# Ensure you own the directory and files
chown -R $USER:$USER ~/.ssh
