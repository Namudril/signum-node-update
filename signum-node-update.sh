#!/bin/bash
cd $HOME
NODE_LINK_DIR="${HOME}/signum-node"
rm -f ./signum-node-v*.zip
CUR_NODE_VER=$(ls -la signum-node | awk -F'signum-node-v' '{gsub(/\.zip/,"",$(NF)); print $(NF)}')
LATEST_NODE_URL=$(curl -s https://api.github.com/repos/signum-network/signum-node/releases/latest \
| awk --posix -F': ' '/browser_download_url/ && /v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.zip[^\.]/ {gsub(/"/, "", $(NF)); print $(NF)}')
LATEST_NODE_VER=$(echo $LATEST_NODE_URL | awk -F'signum-node-v' '{gsub(/\.zip/,"",$(NF)); print $(NF)}')
if [ $CUR_NODE_VER != $LATEST_NODE_VER ] ; then
	echo "Installing signum-node-v${LATEST_NODE_VER}..."
	wget $LATEST_NODE_URL -P $HOME
	NEW_NODE_VER=$(ls signum-node-v*.zip | awk -F'signum-node-v' '{gsub(/\.zip/,"",$(NF)); print $(NF)}')
	NEW_NODE_DIR="${HOME}/signum-node-v${NEW_NODE_VER}"
	rm -rf $NEW_NODE_DIR
	mkdir $NEW_NODE_DIR
	mv -f "${HOME}/signum-node-v${NEW_NODE_VER}.zip" $NEW_NODE_DIR
	cd $NEW_NODE_DIR
	unzip "${NEW_NODE_DIR}/signum-node-v${NEW_NODE_VER}.zip"
	rm -f "${NEW_NODE_DIR}/signum-node-v${NEW_NODE_VER}.zip"
	cp -f "${NODE_LINK_DIR}/conf/node.properties" "${NEW_NODE_DIR}/conf/"
	systemctl stop signum-node.service
	rm -f $NODE_LINK_DIR
	ln -s $NEW_NODE_DIR $NODE_LINK_DIR
	systemctl start signum-node.service
else
	echo "signum-node is already the newest version (${LATEST_NODE_VER})"
fi
