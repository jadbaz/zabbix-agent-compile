PCRE_VERSION=8.44
ZABBIX_VERSION=4.4.8
OPENSSL_VERSION=1.1.1g

### gcc ###
test ! `which gcc` && test `which apt-get` && apt-get install g++
test ! `which gcc` && test `which yum` && yum install g++

### PCRE ###
cd /usr/local/src
wget https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.zip
unzip pcre-$PCRE_VERSION.zip
cd pcre-$PCRE_VERSION

time ./configure
time make
time make install
ldconfig


### OpenSSL ###
# https://unix.stackexchange.com/questions/293311/install-openssl-from-source
cd /usr/local/src
wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
tar -xzvf openssl-$OPENSSL_VERSION.tar.gz
cd openssl-$OPENSSL_VERSION

time ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl 
time make
time make install


### ZABBIX ####
cd /usr/local/src

wget https://cdn.zabbix.com/stable/$ZABBIX_VERSION/zabbix-$ZABBIX_VERSION.tar.gz
tar -xzvf zabbix-$ZABBIX_VERSION.tar.gz
cd zabbix-$ZABBIX_VERSION

addgroup --system --quiet zabbix
adduser --quiet --system --disabled-login --ingroup zabbix --home /var/lib/zabbix --no-create-home zabbix

time ./configure --enable-agent --with-openssl=/usr/local/openssl --enable-static-libs
time make

ZABBIX_BIN_DIR=zabbix-$ZABBIX_VERSION-`uname -s`_`uname -m`
mkdir $ZABBIX_BIN_DIR
cp -t $ZABBIX_BIN_DIR src/zabbix_agent/zabbix_agentd src/zabbix_sender/zabbix_sender src/zabbix_get/zabbix_get

tar -czvf ${ZABBIX_BIN_DIR}.tar.gz $ZABBIX_BIN_DIR
md5sum ${ZABBIX_BIN_DIR}.tar.gz | awk '{print $1}' > ${ZABBIX_BIN_DIR}.tar.gz.md5
cp -t /tmp/ ${ZABBIX_BIN_DIR}.tar.gz ${ZABBIX_BIN_DIR}.tar.gz.md5

echo
echo "**********************************************************************"
echo "Compiled zabbix agent binaries at: /tmp/${ZABBIX_BIN_DIR}.tar.gz"
echo "md5sum file: /tmp/${ZABBIX_BIN_DIR}.tar.gz.md5"
echo "md5sum: `cat ${ZABBIX_BIN_DIR}.tar.gz.md5`"
