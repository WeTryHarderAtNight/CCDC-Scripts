#!/bin/bash

#Gathering requirements
sudo apt-get -y install build-essential zlib1g-dev libevent-dev 

#Pulling tar file
wget https://github.com/ossec/ossec-hids/archive/3.2.0.tar.gz
tar -zxvf 3.2.0.tar.gz

#Run installation package
cd ossec-hids-3.2.0
sudo ./install.sh

#Run manager server package
sudo /var/ossec/bin/ossec-control start