#!/usr/bin/sh
DATE=`date +%Y%m%d%H%M%S`

JBOSS_HOME=/opt/jboss-eap-7.4
SERVER_NAME=server1
SERVER_BASE=$HOME/node/server1
PROP_DIR=$(dirname $0)
# log directory 를 생성하고 권한 줄 것
LOG_HOME=/jboss/log/${SERVER_NAME}
# JAVA_OPTS 는 standalone.conf 파일 수정
export RUN_CONF=$HOME/server1_standalone.conf
# nohup log 이동 관련 제거, nohup log 파일명에 생성일 추가
nohup $JBOSS_HOME/bin/standalone.sh -DSERVER=$SERVER_NAME -P=$PROP_DIR/env.properties -Djboss.server.base.dir=$SERVER_BASE >> $LOG_HOME/nohup/${SERVER_NAME}_${DATE}.out  2>&1 &

if [ $1 ="enotail" ]
then
     echo "Starting... $SERVER_NAME"
     exit;
fi