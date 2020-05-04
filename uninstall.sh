rm -f /usr/local/bin/zabbix_sender
rm -f /usr/local/bin/zabbix_get

rm -f /usr/local/share/man/man1/zabbix_get.1
rm -f /usr/local/share/man/man1/zabbix_sender.1

rm -f /usr/local/sbin/zabbix_agentd
rm -rf /usr/local/etc/zabbix_agentd.conf.d
rm -f /usr/local/etc/zabbix_agentd.conf

rm -f /usr/local/share/man/man8/zabbix_agentd.8

update-rc.d -f zabbix-agent remove
rm -f /etc/init.d/zabbix-agent
userdel zabbix
groupdel zabbix
