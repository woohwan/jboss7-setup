#!/bin/bash

reldir=$(dirname $0)

unset JBOSS_HOME

/opt/jboss-eap-7.4//bin/add-user.sh -sc ${reldir}/configuration -dc ${reldir}/configuration