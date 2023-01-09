# Signum Node update script
Bash script for automatic cheking for and installation of updates of signum-network/signum-node on GNU Linux based systems.

Tested on Debian 11 "bullseye" release.

## Requirements
* signum-node is running as a service named **signum-node.service**
* symbolic link ***/root/signum-node -> /path/to/signum-node-vN.N.N*** where ***N.N.N*** refers to any current or old version, e.g. ***3.5.2***
* custom node properties file **/conf/node.properties** exists
* script is croned as **root** user

## Fulfill requirements

1. Create or copy a custom service:

`sudo nano /etc/systemd/system/signum-node.service`

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
`sudo systemctl daemon-reload`
then enable and run the service:
`sudo systemctl enable signum-node.service`
`sudo systemctl start signum-node.service`
Status should be **active (running)**:
`sudo systemctl status signum-node.service`
