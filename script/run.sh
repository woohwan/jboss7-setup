#!/bin/bash

bind_address=172.20.2.190
mgmt_address=${bind_address}
#node_name=node01
port_offset=0
server_config_file=standalone-ha.xml

reldir=$(dirname $0)

profile_dir=${reldir##*/}
[ "${profile_dir}" = "." ] && profile_dir=$(pwd)

#
# The node name is how a JBoss instance identifies itself in a cluster. If you intend to
# stand up a cluster comprising of multiple JBoss nodes running on the same host, then it
# makes sense to maintain configuration for those nodes in different profile
# sub-directories under the same 'profile' directory. The node name will be inferred from
# the name of the profile directory. This is the default behavior. However, if you intend
# to stand up a cluster where the nodes run on different hosts,  then it is better to use
# the same name for the profile directory across nodes  (management uniformity across the
# cluster) and infer the node name from the host name.
#
node_name=${profile_dir##*/}
#node_name=$(hostname -s)

export RUN_CONF=${reldir}/profile.conf

#
# Use ${PROFILE_DIR} in ${RUN_CONF} definitions
#
export PROFILE_DIR=$(dirname $0)

unset JBOSS_HOME

/opt/jboss-eap-7.4/bin/standalone.sh \
 --server-config=${server_config_file} \
 -Djboss.bind.address=${bind_address} \
 -Djboss.bind.address.management=${mgmt_address} \
 -Djboss.server.base.dir=${reldir} \
 -Djboss.node.name=${node_name} \
 -Djboss.socket.binding.port-offset=${port_offset}