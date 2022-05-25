### list reource  
- list datasource  
data-source read-resource --name OracleDS  
/subsystem=datasources:read-resource


./jboss-cli.sh --connect --command="/subsystem=datasources:read-resource" | grep "data-source"  
 
 /core-service=module-loading:list-resource-loader-paths(module=com.oracle)  
 ./jboss-cli.sh --connect --command="/core-service=module-loading/:list-resource-loader-paths(module=com.oracle)"  



- remove
./jboss-cli.sh --connect --command="/subsystem=datasources/data-source=OracleDS:remove,reload"   
./jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=oracle/:remove"  
./jboss-cli.sh --connect --command="module remove --name=com.oracle,:shutdown(restart=true)
"  