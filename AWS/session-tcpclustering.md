**application 이 deploy되어야 clustering 구성 시작**  



#### install mod_cluster module in Apache HTTP Server  
ref: https://github.com/modcluster/mod_proxy_cluster/tree/main/native  
```  
mkdir build
cd build/
cmake ../ -G "Unix Makefiles"
Output 
-- Found APR: /usr/lib64/libapr-1.so
-- Found APRUTIL: /usr/lib64/libaprutil-1.so
-- Found APACHE: /usr/include/httpd  
-- Configuring done
-- Generating done
-- Build files have been written to: /opt/mod_cluster-cmake/build

make
ls modules/
    mod_advertise.so  mod_cluster_slotmem.so  mod_manager.so  mod_proxy_cluster.so
cp modules/*.so /etc/httpd/modules  
```      


### Configure mod_cluster in Apache HTTP Server  
1. Configure mod_cluster  
- mod_cluster file  생성 (under /etc/httpd/conf.modules.d )  


 ### Disable Advertising for mod_cluster  
in HTTP Server  mod_cluster config file
```  
ServerAdvertise Off
```  
2. mod_cluster setting using cli for Each JBoss EAP  instance
아래 내용은 모두 mod_cluster.cli에 포함됨.
- Disable Advertising
 ```  
/subsystem=modcluster/mod-cluster-config=configuration/:write-attribute(name=advertise,value=false)  
```  

### Modify interface IP
```  
/interface=management:write-attribute(name=inet-address,value="${jboss.bind.address.management:172.31.12.7}")
/interface=public:write-attribute(name=inet-address,value="${jboss.bind.address:172.31.12.7}")
```  

### Modify modcluster  
```  
/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=proxy1:add(host=172.31.2.106,port=6666)
/subsystem=modcluster/proxy=default:write-attribute(name=proxies,value=[proxy1])
```  


### Troubleshooting

test 시 ERR_UNSAFE_PORT  
크롬 경우   
명령어 줄에 --explicitly-allowed-ports=6666  추가  