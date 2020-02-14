#!/bin/bash

#Gathering requirements
sudo yum -y install wget

#Pulling repo
sudo wget -q -O - https://updates.atomicorp.com/installers/atomic | sudo bash

#Install sever package
sudo yum install install ossec-hids-server

#Run manager server package

sudo /var/ossec/bin/ossec-control start