#!/bin/bash
apt-get install -y build-essential cmake bison flex libpcap-dev pkg-config libglib2.0-dev libgpgme11-dev uuid-dev sqlfairy xmltoman doxygen libssh-dev libksba-dev libldap2-dev libsqlite3-dev libmicrohttpd-dev libxml2-dev libxslt1-dev xsltproc clang rsync rpm nsis alien sqlite3 libhiredis-dev libgcrypt11-dev libgnutls28-dev redis-server nmap texlive-latex-base texlive-latex-recommended linux-headers-$(uname -r)

# Make temporary directory to d/l source, extract and compile
cd ~
mkdir openvas
cd openvas

# Download Source
wget http://wald.intevation.org/frs/download.php/2351/openvas-libraries-8.0.8.tar.gz
wget http://wald.intevation.org/frs/download.php/2367/openvas-scanner-5.0.7.tar.gz
wget http://wald.intevation.org/frs/download.php/2359/openvas-manager-6.0.9.tar.gz
wget http://wald.intevation.org/frs/download.php/2363/greenbone-security-assistant-6.0.11.tar.gz
wget http://wald.intevation.org/frs/download.php/2332/openvas-cli-1.4.4.tar.gz

# Extract packages
tar xvf greenbone-security-assistant-6.0.11.tar.gz
tar xvf openvas-libraries-8.0.8.tar.gz
tar xvf openvas-scanner-5.0.7.tar.gz
tar xvf openvas-manager-6.0.9.tar.gz
tar xvf openvas-cli-1.4.4.tar.gz
tar xvf nmap-5.51.6.tgz

# Compile and install packages
cd openvas-libraries-8.0.8
cmake .
make
make doc
make install
cd ..

cd openvas-manager-6.0.9/
cmake .
make
make doc
make install
cd ..

cd openvas-scanner-5.0.7/
cmake .
make
make doc
make install
cd ..

cd openvas-cli-1.4.4/
cmake .
make
make doc
make install
cd ..

cd greenbone-security-assistant-6.0.11/
cmake .
make
make doc
make install
cd ..

cd nmap-5.51.6
./configure
make
make install
cd ..

ldconfig
