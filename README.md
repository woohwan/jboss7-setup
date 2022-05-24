### jboss7-setup  

1. install JBoss EAP 7.4  
   - unzip  
 ```
sudo unzip ./jboss-eap-7.4.0.zip -d /opt
```
   - jboss 계정 생성  
```   
sudo useradd -r -d /home/jboss jboss
```
   - .bash_profile  수정  - 아래 추가 후 source 수행  
 ```  
  echo "export JBOSS_HOME=/opt/jboss" >> ~/.bash_profile  
  source ~/.bash_profile
  echo $JBOSS_HOME
 ```  
   - symbolic link 생성  및 권한 변경  
 ```  
ln -s /opt/jboss-eap-7.4 /opt/jboss
sudo chown -Rf jboss:jboss $JBOSS_HOME
sudo chmod +x /opt/jboss/bin/*.sh
```

1. Install binary와 무관하게 standalone 구성  
    변경해야 부분: module directory, deploy directory, welcome-contents (static contents) directory  
    module directory: JBOSS_MODULEPATH 변경 ( for standalone.sh, jboss-cli.sh)  
    ( 참고: https://access.redhat.com/solutions/195733 )  

    - instance directory 생성   
    ```  
    mkdir -p $HOME/node1
    sudo cp  $JBOSS_HOME/standalone node1
    sudo chown -R jboss:jboss $HOME/node1
    ```   

    - 관리자 추가  
    jboss user로 실행  
    `$ mkdir script`  
    script로 디렉토리로
    - deploy directory 변경  
    standalon.xml에 <paths> element를 아래와 같이 추가 및 변경  
    </extensions> 와 <management> 사이
    ```
    </extensions>
    <paths>
      <path name="deploy.dir" path="/home/admin/node/server1"/>
    </paths>
    <management>
    ```
    deployment scanner 변경
    ```
    <subsystem xmlns="urn:jboss:domain:deployment-scanner:2.0">
        <deployment-scanner path="deployments" relative-to="deploy.dir" scan-interval="5000" runtime-failure-causes-rollback="${jboss.deployment.scanner.rollback.on.failure:false}"/>
    </subsystem>
    ```

    - 정적 contents 경로 지정 (예: welcome-contents)  
     handler 변경
     ```
    <handlers>
         <file name="welcome-content" path="/home/admin/node/server1/welcome"/>
    </handlers>
    ```




2. JBoss JDBC 구성
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

