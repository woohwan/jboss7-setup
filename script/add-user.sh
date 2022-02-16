#!/bin/sh

JBOSS_HOME=/opt/jboss-eap-7.4
NODE_DIR=$HOME/node
SERVER_NAME=server1
export JAVA_OPTS="-Djboss.server.config.user.dir=$NODE_DIR/$SERVER_NAME/configuration"
$JBOSS_HOME/bin/add-user.sh  $@
