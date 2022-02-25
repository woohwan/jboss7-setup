#!/bin/sh

export JBOSS_HOME=/opt/jboss-eap-7.4
export JBOSS_MODULEPATH="$HOME/node/modules:$JBOSS_HOME/modules"
export JAVA_OPTS="-Djava.awt.headless=false"
export USER_HOME=$HOME
CONTROLLER_IP=172.20.2.190
CONTROLLER_PORT=9990
$JBOSS_HOME/bin/jboss-cli.sh  --controller=$CONTROLLER_IP:$CONTROLLER_PORT --connect $@