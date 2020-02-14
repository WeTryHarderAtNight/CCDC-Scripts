#!/bin/bash

clear

#Grabs all current users that are able to login and displayes service accounts, also changes the passwords
#and disables accounts if necessary

# echo "The following accounts are able to login:"
users=$(cat /etc/passwd | grep /bin/bash | awk -F':' '{ print $1}')
# for f in $users;
# do
#   echo $f
# done

# sleep 10

# # echo "Changing passwords for the following:"
# # for f in $users;
# # do
# #   echo $f
# #   sudo passwd $f
# # done

# echo "Do any of these accounts stand out? Type yes or no:"

# for u in $users;
# do
#   echo "Disable the account $u?"
#   read user_disable
#   if [ $user_disable == "no" ]
#   then
#     :
#   else
#     usermod -L $service_account
#   fi
# done

# sleep 10
# clear

# echo "The following accounts are service accounts:"
# user_accounts=$(cat /etc/passwd | grep -v /bin/bash | awk -F':' '{print $1}')
# for f in $user_accounts;
# do
#   echo $f
# done

# sleep 10

# echo "Do any of these accounts stand out? If yes type the name in now to change the password and disable. If none, type in 'none':"
# read service_account

# if [ $service_account == "none" ]
# then
#   :
# else
#   sudo passwd $service_account
#   usermod -L $service_account
# fi

# clear

# #Checks and changes current SSH configuration to be more secure
# #Checks for allow root login
# if [ -z "$(sudo cat /etc/ssh/sshd_config | grep -v '#' | grep "PermitRootLogin yes")" ]
# then
#   echo "No fault found in PermitRootLogin"
#   :
# else
#   sudo sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
#   echo "PermitRootLogin changed"
# fi

# sleep 5

# #checks for password auth
# if [ -z "$(sudo cat /etc/ssh/sshd_config | grep -v '#' | grep "PasswordAuthentication yes")" ]
# then
#   echo "No fault found in PasswordAuthentication"
#   :
# else
#   sudo sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config
#   echo "PasswordAuthentication changed"
# fi

# sleep 5

# #Removes any pre existing keys or other nonsense
# echo "Removing directory .ssh found in users homes"
# ssh_dirs=$(sudo find / -iname ".ssh")
# for dir in $ssh_dirs;
# do
#   sudo rm -rf $dir
# done
# echo "Done"
# sleep 5
# clear

# #Checks for running cronjobs for root, and all other users
# echo "Checking cronjobs for all users:"
# for u in $users;
# do
#   echo ""
#   echo "Cronjob for $u:"
#   sudo -u $u crontab -l
#   sleep 5
# done

# sleep 10

# echo ""
# echo "Do you wish to modify any cronjobs? Enter yes or no when asked:"

# for u in $users;
# do
#   echo "Modify crontab for $u?"
#   read user_cron

#   if [ $user_cron == "yes" ]
#   then
#     sudo -u $u crontab -e
#   else
#     :
#   fi
# done

# clear

# #Shows open connections based on netstat and gives PID and possible service its coming from
# sudo netstat -ntlp

# echo ""
# pid=0
# while [ $pid != "none" ]
# do
#   echo "Is there a PID you wish to kill?"
#   read pid
#   if [ $pid == "none" ]
#   then
#     :
#   else
#     sudo kill $pid
#   fi
# done

clear

#Delete firewall rules function
remove_firewall_service () {
  if [ $1 == "port" ]
  then
    port=0
    while [ $port != "none" ]
    do
      echo "What port would you live removed? (Type in as 123/tcp or 123/udp format) Type none when finished:"
      read port
      sudo firewall-cmd --permanent --zone=public --remove-port=$port
    done
  else
    service=0
    while [ $service != "none" ]
    do
      echo "What service would you live removed? (Type exactly as displayed on the console) Type none when finished:"
      read service
      sudo firewall-cmd --permanent --zone=public --remove-service=$service
    done
  fi
}

remove_firewall_rule () {
  echo $1
}

#View current firewall rules/iptables
version=$(cat /etc/*os-release | grep -w "NAME=")
if [ "$version" == *"Debian"* ]
then
  echo "Displaying current incoming firewall rules"
  sudo iptables -L INPUT --line-numbers
  echo ""
  echo "Type a rule number you wish to remove for an unused port for incoming connections:"
  read rule
  remove_firewall_rule $answer
  echo "Displaying current outgoing firewall rules"
  sudo iptables -L OUTPUT --line-numbers
  echo ""
  echo "Type a rule number you wish to remove for an unused port for outgoing connections:"
  read rule
  remove_firewall_rule $answer
else
  echo "Displaying current firewall rules"
  sudo firewall-cmd --list-all
  echo "Type 'port' or 'service' to removed unused rules:"
  read answer
  remove_firewall_service $answer
  echo "Reloading firewall"
  sudo firewall-cmd --reload
fi