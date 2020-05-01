# zabbix-agent-compile

Run all steps as root
## Download
- cd /usr/local/src
- `git clone https://github.com/jadbaz/zabbix-agent-compile`

## Compile
### log to stdout
`sh compile_zabbix_agent_openssl_static_portable.sh`

### log to file
`sh compile_zabbix_agent_openssl_static_portable.sh >> zabbix_compile.log`

### Result
- Result will be created under /tmp/zabbix-${ZABBIX_VERSION}_agent_dist_`uname -s`_`uname -m`.tar.gz
- Copy this file to target machines

## Install on target machine
### Download
Get archive already built and cd into it

### Run installer
`sh install_zabbix_from_compiled_sources.sh`

## Run
`service zabbix-agent start`
