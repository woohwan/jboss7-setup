# jboss7-setup  

1. Download JBoss EAP 7.4  
   - 


2. Oracle DB install 및 sample DB 생성  
    2.1  docker image 사용  
    https://hub.docker.com/r/gvenzl/oracle-xe
    
    2.2  docker run 실행  
    `podman run -d -p 1521:1521 -e ORACLE_PASSWORD=oracle -v oracle-volume:/opt/oracle/oradata gvenzl/oracle-xe:11 --name oracle-xe-11g`
    
    2.3 sample user 및 table 생성
    $ podman cp scott.sql  oracle-xe-11g:/u01/app/oracle  
    $ podman exec -it oracle-xe-11g bash  
    $ ls  
    $ sqlplus / as sysdba  
    SQL> @scott.sql  
    SQL> conn scott/tiger  
    SQL> select table_name from user_tables;  

    2.4 sqlplus TIP (sqlplus / as sysdba)  
    - database name 확인  
      SQL> select name, db_unique_name from v$database;  
    - sid 확인  
      SQL> select instance from v$thread


3. JBoss JDBC 구성
    3.1 module directory 생성 및  jdbc driver upload  
    $ mkdir -p $JBOSS_HOME/modules/com/oracle/main  
    $ mv ojdbc6.jar $JBOSS_HOME/modules/com/oracle/main/.  
    
    3.2 module.xml 파일 작성 (ojbdc6.jar 과 동일 위치)
    ```
    <?xml version="1.0" encoding="UTF-8"?>  
    <module xmlns="urn:jboss:module:1.3" name="com.oracle">  
      <resources>  
        <resource-root path="ojdbc6.jar"/>  
      </resources>
      <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
        <module name="javax.servlet.api" optional="true"/>
      </dependencies>
    </module>
    ```
    3.4 standalone.xml 에 datasource 및 driver  추가  
    ```
    <datasources>
        <datasource jta="true" jndi-name="java:jboss/OracleDS" pool-name="OrderDS" enabled="true" use-ccm="false">
            <connection-url>jdbc:oracle:thin:@172.20.2.190:1521:xe</connection-url>
            <driver>OracleJDBCDriver</driver>
            <transaction-isolation>TRANSACTION_READ_COMMITTED</transaction-isolation>
            <pool>
                <min-pool-size>3</min-pool-size>
                <max-pool-size>5</max-pool-size>
                <prefill>true</prefill>
                <use-strict-min>true</use-strict-min>
            </pool>
            <security>
                <user-name>scott</user-name>
                <password>tiger</password>
            </security>
            <statement>
                <prepared-statement-cache-size>32</prepared-statement-cache-size>
            </statement>
            <validation>
                <check-valid-connection-sql>select 1 from dual</check-valid-connection-sql>
                <validate-on-match>false</validate-on-match>
                <background-validation>true</background-validation>
                <background-validation-millis>30000</background-validation-millis>
                <exception-sorter class-name="org.jboss.resource.adapter.jdbc.vendor.OracleExceptionSorter"/>
            </validation>
            <timeout>
                <idle-timeout-minutes>15</idle-timeout-minutes>
            </timeout>
        </datasource>
        <drivers>
            <driver name="OracleJDBCDriver" module="com.oracle">
                <driver-class>oracle.jdbc.OracleDriver</driver-class>
            </driver>
        </drivers>
    </datasources>
    ```

