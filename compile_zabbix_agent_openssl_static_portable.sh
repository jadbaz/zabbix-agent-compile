wd=`pwd`

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
tar -xzf openssl-$OPENSSL_VERSION.tar.gz
cd openssl-$OPENSSL_VERSION

time ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl 
time make
time make install


### ZABBIX ####
cd /usr/local/src

wget https://cdn.zabbix.com/stable/$ZABBIX_VERSION/zabbix-$ZABBIX_VERSION.tar.gz
tar -xzf zabbix-$ZABBIX_VERSION.tar.gz
cd zabbix-$ZABBIX_VERSION

addgroup --system --quiet zabbix
adduser --quiet --system --disabled-login --ingroup zabbix --home /var/lib/zabbix --no-create-home zabbix

time ./configure --enable-agent --with-openssl=/usr/local/openssl --enable-static-libs
time make
# make install if you want to install here
# time make install


### PACKAGE FOR USE ELSEWHERE ###
ZABBIX_PACKAGE_DIR="zabbix-${ZABBIX_VERSION}_agent_dist_`uname -s`_`uname -m`"
ZABBIX_PACKAGE="${ZABBIX_PACKAGE_DIR}.tar.gz"
mkdir -p $ZABBIX_PACKAGE_DIR/{bin,conf,man,init.d}
cp -t $ZABBIX_PACKAGE_DIR/bin src/zabbix_agent/zabbix_agentd src/zabbix_sender/zabbix_sender src/zabbix_get/zabbix_get
cp -t $ZABBIX_PACKAGE_DIR/conf conf/zabbix_agentd.conf 
cp -t $ZABBIX_PACKAGE_DIR/man man/{zabbix_agentd,zabbix_sender,zabbix_get}.man
cp -t $ZABBIX_PACKAGE_DIR/init.d misc/init.d/debian/zabbix-agent

#cp $wd/zabbix-agent.init $ZABBIX_PACKAGE_DIR/init.d/zabbix-agent
cp $wd/install_zabbix_from_compiled_sources.sh $ZABBIX_PACKAGE_DIR

tar -czf ${ZABBIX_PACKAGE} ${ZABBIX_PACKAGE_DIR}
md5sum ${ZABBIX_PACKAGE} | awk '{print $1}' > ${ZABBIX_PACKAGE}.md5
cp -t /tmp/ ${ZABBIX_PACKAGE} ${ZABBIX_PACKAGE}.md5

echo
echo "**********************************************************************"
echo "Compiled zabbix agent dist: /tmp/${ZABBIX_PACKAGE}"
echo "Compiled zabbix agent dist md5: /tmp/${ZABBIX_PACKAGE}.md5"
echo "md5sum: `cat ${ZABBIX_PACKAGE}.md5`"