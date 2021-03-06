# 외부 module directory에 jdbc driver module 추가 (eap 7.1 이상)  
```
module add --module-root-dir=/home/admin/node/modules --name=com.oracle  \  
--resources=/home/admin/resources/ojdbc8.jar \  
--dependencies=javax.api,javax.transaction.api  
```

# jdbc Driver 등록  
```
/subsystem=datasources/jdbc-driver=oracle:add(driver-name=oracle, \
driver-module-name=com.oracle, \
jdbc-compliant=true, \
driver-class-name=oracle.jdbc.OracleDriver, \
xa-datasource-class=oracle.jdbc.xa.client.OracleXADataSource)
```

# datasource 등록  
```
/subsystem=datasources/data-source=OracleDS:add(driver-name=oracle, \
jndi-name="java:jboss/datasources/oracleDS", \
connection-url="jdbc:oracle:thin:@172.20.2.190:1521:ORCLCDB", \
driver-name=oracle, user-name=scott, password=tiger, \
validate-on-match=true, \
valid-connection-checker-class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker", \
exception-sorter-class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleExceptionSorter", \
min-pool-size=5, max-pool-size=10, pool-prefill=true, \
prepared-statements-cache-size=32, \
check-valid-connection-sql="select 1 from dual", \
background-validation=true, background-validation-millis=30000, \
idle-timeout-minutes=15)
```

# server reload  
`:reload`

# datasource connection test  
 `/subsystem=datasources/data-source=OracleDS:test-connection-in-pool`