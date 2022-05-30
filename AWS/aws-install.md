# on Amazon Linux 2  

### 준비물: jboss-eap-7.4.0.zip, jboss-eap-7.4.4-patch.zip, script.tar, 
## JDK 설치  
```  
sudo yum install -y java-1.8.0-openjdk-devel  
sudo yum install -y java-1.8.0-openjdk  
```  
## JBOSS 7 download 및 install  
root account로    
1. 설치 파일은 브라우저을 통해 다운로드하거나 별도로 받아서 올린다.  
```  
mkdir download
scp -i C:\tools\aws-ec2.pem jboss-eap-7.4.0.zip ec2-user@43.200.6.219:/root/download
scp -i C:\tools\aws-ec2.pem jboss-eap-7.4.4-patch.zip ec2-user@43.200.6.219:/root/download
scp -i C:\tools\aws-ec2.pem script.tar ec2-user@43.200.6.219:/root/download

mkdir /JBOSS
unzip download/jboss-eap-7.4.0.zip -d /JBOSS
```  

2. jboss account 생성
```   
sudo groupadd jboss
sudo useradd -r -g jboss jboss
```  

3.  환경 설정

```  
#  node 및 log directory 생성
echo "export JBOSS_HOME='/opt/jboss-eap-7.4'" >>  $HOME/.bash_profile
echo "alias node1='cd /home/ec2-user/domains/node1'
" >> ~/.bash_profile
source ~/.bash_profile
mkdir -p /JBOSS/domains/node1
cd 
cp -r $JBOSS_HOME/standalone/* /JBOSS/domains/node1

```  

4. 필요 스크립트 복사
```     
mkdir -p /JBOSS/domains/node1/bin   
tar xvf $HOME/download/script.tar -C /JBOSS/domains/node1/bin
  
```  

5. 로그 디렉터리 생성  
```   
mkdir -p /JBOSS/LOG/node1/gclog
mkdir -p /JBOSS/LOG/node1/nohup

chown -R jboss:jboss $JBOSS_HOME
chown -R jboss:jboss /JBOSS/LOG
chown -R jboss:jboss /JBOSS/domains/
```  
```   
# script file  수정 후  
sudo -u jboss ./start.sh
```  

6. 관리자 등록 (admin/password)
```     
sudo ./add-user.sh
 
a) Management User (mgmt-user.properties)
 
b) Application User (application-user.properties)
 
(a) : a 선택 후 진행
```  

참고: --------------------------
Updated user 'admin' to file '/CLOUD/JBOSS/jboss-eap-7.4/standalone/configuration/mgmt-users.properties'
Updated user 'admin' to file '/CLOUD/JBOSS/jboss-eap-7.4/domain/configuration/mgmt-users.properties'
Updated user 'admin' with groups  to file '/CLOUD/JBOSS/jboss-eap-7.4/standalone/configuration/mgmt-groups.properties'
Updated user 'admin' with groups  to file '/CLOUD/JBOSS/jboss-eap-7.4/domain/configuration/mgmt-groups.properties'
---

### Patch Using management CLI
```  
chmod 775 $JBOSS_HOME/.installation
cp $HOME/download/jboss-eap-7.4.4-patch.zip /JBOSS/domains/node1/bin/
sudo -u jboss ./jboss-cli.sh  

patch apply jboss-eap-7.4.4-patch.zip

{
    "outcome" : "success",
    "response-headers" : {
        "operation-requires-restart" : true,
        "process-state" : "restart-required"
    }
}

``` 
1. 보안 취약점 조치
2) 관리자 콘솔 관리(접속 포트변경)
# vim /CLOUD/JBOSS/domains/노드명/configuration/standalone-ha.xml
 
<socket-binding name="management-http" interface="management" port="${jboss.management.http.port:9990}"/>
 
==>
 
<socket-binding name="management-http" interface="management" port="${jboss.management.http.port:9991}"/>

2) JSP 파일 자동 로딩 금지 및 powered-by 출력 금지
# vim /CLOUD/JBOSS/domains/노드명/configuration/standalone-ha.xml
 
※ JBoss EAP 7.x
<servlet-container name="default">
     <jsp-config x-powered-by="false" development="false" check-interval="60"/>
     <websockets/>
</servlet-container>
 
 
※ JBoss EAP 6.4.x
<subsystem xmlns="urn:jboss:domain:web:1.5" default-virtual-server"default-host" instance-id="${jboss.node.name}" native="false">
     <configuration>
          <jsp-configuration development="true" check-interval=5" modification-test-interval="5" recompile-on-fail="true" x-powered-by="false"/>
     </configuration>


3) 패스웥드 관리
# cd /CLOUD/JBOSS/domains/노드명/configuration
chmod 640 mgmt-* application-*

4)설정파일 디렉터리 퍼미션 변경
chmod 700 /CLOUD/JBOSS/domains/노드명/configuration/standalone_xml_history

5) 로깅 디렉터리 및 파일 권한 관리
# vim /CLOUD/JBOSS/jboss-eap-7.2/bin/standalone.conf
 
if [ "x$GC_LOG" = "x" ]; then
     GC_LOG="false"
else
     echo "GC_LOG set in environment to $GC_LOG"
fi
 
# find /CLOUD/JBOSS/LOG -type f | xargs chmod 640
# find /CLOUD/JBOSS/LOG -type d | xargs chmod 750

6. 샢믚 디렉터리 삭제
rm -rf /CLOUD/JBOSS/jboss-eap-7.2/docs/examples


8. 데이터소스 설정
mkdir jdbc  
mv ojdbc8.jar jdbc/  
datasource batch 실행   
```  
cat <<EOF > add-oracle-ds.cli
module add --name=com.oracle  \
--resources=/home/ec2-user/jdbc/ojdbc8.jar \
--dependencies=javax.api,javax.transaction.api

connect

# register jdbc driver
/subsystem=datasources/jdbc-driver=oracle:add(driver-name=oracle, \
driver-module-name=com.oracle, \
jdbc-compliant=true, \
driver-class-name=oracle.jdbc.OracleDriver, \
xa-datasource-class=oracle.jdbc.xa.client.OracleXADataSource)

# register oracle ds
/subsystem=datasources/data-source=OracleDS:add(driver-name=oracle, \
  jndi-name="java:jboss/datasources/oracleDS", \
  connection-url="jdbc:oracle:thin:@172.31.37.245:49161:XE", \
  driver-name=oracle, user-name=scott, password=tiger, \
  validate-on-match=true, \
  valid-connection-checker-class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker", \
  exception-sorter-class-name="org.jboss.jca.adapters.jdbc.extensions.oracle.OracleExceptionSorter", \
  min-pool-size=5, max-pool-size=10, pool-prefill=true, \
  prepared-statements-cache-size=32, \
  check-valid-connection-sql="select 1 from dual", \
  background-validation=true, background-validation-millis=30000, \
  idle-timeout-minutes=15)

run-batch
```  
server restart: ./stop.sh & sudo -u jboss ./start.sh  
connection 테스트  
./jboss-cli.sh  
] /subsystem=datasources/data-source=OracleDS:test-connection-in-pool







