#!/usr/bin/bash

CONTROLLER_IP=172.20.2.190
CONTROLLER_PORT=9990
JBOSS_HOME=/opt/jboss-eap-7.4
$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$CONTROLLER_IP:$CONTROLLER_PORT --command="read-attribute server-state"