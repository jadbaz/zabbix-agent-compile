# download package and cd into it

/bin/mkdir -p '/usr/local/bin'
/usr/bin/install -c bin/zabbix_sender '/usr/local/bin'
/usr/bin/install -c bin/zabbix_get '/usr/local/bin'

/bin/mkdir -p '/usr/local/share/man/man1'
/usr/bin/install -c -m 644 'man/zabbix_get.man' '/usr/local/share/man/man1/zabbix_get.1'
/usr/bin/install -c -m 644 'man/zabbix_sender.man' '/usr/local/share/man/man1/zabbix_sender.1'


/bin/mkdir -p '/usr/local/sbin'
/usr/bin/install -c bin/zabbix_agentd '/usr/local/sbin'
/bin/mkdir -p "/usr/local/etc/zabbix_agentd.conf.d"
/bin/mkdir -p "/usr/local/lib/modules"
test -f "/usr/local/etc/zabbix_agentd.conf" || cp "conf/zabbix_agentd.conf" "/usr/local/etc/zabbix_agentd.conf"

/bin/mkdir -p '/usr/local/share/man/man8'
/usr/bin/install -c -m 644 'man/zabbix_agentd.man' '/usr/local/share/man/man8/zabbix_agentd.8'

cp init.d/zabbix-agent /etc/init.d/zabbix-agent
chmod +x /etc/init.d/zabbix-agent
update-rc.d zabbix-agent defaults
