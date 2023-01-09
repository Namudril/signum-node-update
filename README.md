# Signum Node update script
Bash script for automatic checking for and installation of updates of [signum-network/signum-node](https://github.com/signum-network/signum-node) on GNU Linux based systems.

Tested on Debian 11 "bullseye" release.

## Requirements
* symbolic link ***/root/signum-node -> /path/to/signum-node-vN.N.N*** where ***N.N.N*** refers to any current or old version, e.g. ***3.5.2***
* signum-node is running as a service named **signum-node.service**
* custom node properties file **/conf/node.properties** exists
* script is croned as **root** user

## Fulfill requirements
### Rename current signum-node folder wherever it is if needed to a required format.
Example:
```
mv -f /path/to/signum-node-folder /path/to/signum-node-v3.5.2
```
Create a symbolic link:
```
sudo ln -s /path/to/signum-node-v3.5.2 /root/signum-node
```

### Create or copy a custom service:
```
sudo nano /etc/systemd/system/signum-node.service
```
Example here:
```
[Unit]

    Description=Signum Node
    After=network.target
    Wants=network.target

[Service]

    ExecStart=/usr/bin/java -jar signum-node.jar -l
    WorkingDirectory=/root/signum-node/
    User=root
    Restart=always
    RestartSec=10

[Install]

    WantedBy=multi-user.target
```
Reload systemd manager configuration:
```
sudo systemctl daemon-reload
```
then enable and run the service:
```
sudo systemctl enable signum-node.service
sudo systemctl start signum-node.service
```
Status should be **active (running)**:
```
sudo systemctl status signum-node.service
```

### Custom node.properties
It's better to leave **/conf/node-default.properties** untouched (default) to let updates come to life and make your changes in a custom properties file. Example:
'''
cp /path/to/signum-node-v3.5.2/conf/node-default.properties /path/to/signum-node-v3.5.2/conf/node.properties
nano /path/to/signum-node-v3.5.2/conf/node.properties
'''

### Schedule script running
```
sudo crontab -e
```
Examples:
```
0 5 * * 0 /root/signum-node-update.sh # check for updates every Sunday at 5:00 AM
0 * * * * /root/signum-node-update.sh # check for updates every hour at 00 minutes
0 */3 * * * /root/signum-node-update.sh # check for updates every 3 hours at 00 minutes
```
