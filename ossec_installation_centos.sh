#!/bin/bash

#Gathering requirements
sudo yum -y install wget zlib-devel binutils gcc libevent-devel openssl-devel

#Pulling tar file
wget https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
tar -zxvf 3.6.0.tar.gz

#pulling down required pcre2
wget http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/p/pcre2-10.21-22.el6.x86_64.rpm
wget http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/p/pcre2-devel-10.21-22.el6.x86_64.rpm

#installing required pcre2 library
sudo rpm -i pcre2-10.21-22.el6.x86_64.rpm
sudo rpm -i pcre2-devel-10.21-22.el6.x86_64.rpm

#Run installation package
sudo ./install.sh
cd ossec-hids-3.6.0

#Run manager server package
sudo /var/ossec/bin/ossec-control start