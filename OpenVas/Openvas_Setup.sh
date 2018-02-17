#!/bin/bash
if ! grep -q "^unixsocket /tmp/redis.sock" /etc/redis/redis.conf ; then
    sed -i -e 's/^\(#.\)\?port.*$/port 0/' /etc/redis/redis.conf
    sed -i -e 's/^\(#.\)\?unixsocket \/.*$/unixsocket \/tmp\/redis.sock/' /etc/redis/redis.conf
    sed -i -e 's/^\(#.\)\?unixsocketperm.*$/unixsocketperm 700/' /etc/redis/redis.conf
fi

service redis-server restart

test -e /usr/local/var/lib/openvas/CA/cacert.pem || openvas-mkcert -q
if (openssl verify -CAfile /usr/local/var/lib/openvas/CA/cacert.pem \
    /usr/local/var/lib/openvas/CA/servercert.pem | grep -q ^error); then
    openvas-mkcert -q -f
fi

openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
if ! test -e /usr/local/var/lib/openvas/CA/clientcert.pem || \
    ! test -e /usr/local/var/lib/openvas/private/CA/clientkey.pem; then
    openvas-mkcert-client -n -i
fi
if (openssl verify -CAfile /usr/local/var/lib/openvas/CA/cacert.pem \
    /usr/local/var/lib/openvas/CA/clientcert.pem |grep -q ^error); then
    openvas-mkcert-client -n -i
fi

openvassd
openvasmd --migrate
openvasmd --progress --rebuild

openvassd
openvasmd
gsad

if ! openvasmd --get-users | grep -q ^admin$ ; then
    openvasmd --create-user=admin
fi
