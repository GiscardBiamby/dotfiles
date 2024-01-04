#!/bin/bash

. ../util.sh

echo "Installing pgadmin"
# https://www.pgadmin.org/download/pgadmin-4-apt/
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

# Install for desktop mode only:
install pgadmin4-desktop
echo "You can copy ~/.pgadmin/pgadmin4.db between machines to transfer server definitions"
