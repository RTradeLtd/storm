# storm

storm is a set of storj storagenode management, and monitoring scripts

## contents

### configs

Used for storm configuration

#### zabbix

`templates/storj_template.xml` zabbix template
`userparameter_storj.conf` zabbix_agent.d configuration for the template

### scripts

`storagenode_management.sh` is a script used to manager a storagenode and perform common operations (identity generation, identity authorization, run, upgrade, etc..)

`storj_monitor.sh` is a script used to monitor your storagenode and can currently check for:

* writable storage directory
* if your node is online
* if your node can bootstrap