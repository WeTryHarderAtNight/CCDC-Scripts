#!/bin/bash

#Installing requirements
sudo yum -y install postfix dovecot php php-mbstring php-pear mod_ssl

#Configuring postfix
#Changing main.cf file
echo "Enter the FQDN for the host (e.g. webmail.metro.club)"
read fqdn
sudo sed -i 's/#myhostname = host.domain.tld/myhostname = $fqdn'
echo ""
echo "Enter the domain name (e.g. metro.club)"
read domain
sudo sed -i 's/#mydomain = domain.tld/mydomain = $domain'
sudo sed -i 's/#myorigin = $mydomain/myorigin = $mydomain'
echo ""
echo "Changing network information"
echo "Enter networks that are accessing the email with comma separated (e.g 172.69.69.0/24, 172.69.242.0/24)"
read networks
sudo sed -i 's/mydestination = $myhostname, localhost.$mydomain, localhost/mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain'
sudo sed -i 's/inet_interfaces = localhost/inet_interfaces = all'
sudo sed -i 's/inet_protocols = all/inet_protocols = ipv4'
sudo sed -i 's/#mynetworks = 168.100.89.0/28, 127.0.0.0/8/mynetworks = $networks'
echo ""
echo "Changing remaining configuration"
sudo sed -i 's/#home_mailbox = Maildir//home_mailbox = Maildir//'
sudo sed -i 's/#smtpd_banner = $myhostname ESMTP $mail_name/smtpd_banner = $myhostname ESMTP'
echo "# limit an email size for 10M\nmessage_size_limit = 10485760\n# limit a mailbox for 1G\nmailbox_size_limit = 1073741824\n# SMTP-Auth settings\nsmtpd_sasl_type = dovecot\nsmtpd_sasl_path = private/auth\nsmtpd_sasl_auth_enable = yes\nsmtpd_sasl_security_options = noanonymous\nsmtpd_sasl_local_domain = $myhostname\nsmtpd_recipient_restrictions = permit_mynetworks, permit_auth_destination, permit_sasl_authenticated, reject" >> /etc/postfix/main.cf