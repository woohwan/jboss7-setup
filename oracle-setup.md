1. Oracle DB install 및 sample DB 생성  
    1.1  oracle docker image  term agree
    https://hub.docker.com/_/oracle-database-enterprise-edition?tab=resources  
    --> preceed checkout -> developer terms aggree

    
    2.2  docker run 실행 및 확인  
    - container 시작 (oracle deprecated)
    `$ docker run -d -it -p 1521:1521 --name oradb store/oracle/database-enterprise:12.2.0.1-slim`  

    - container log 확인  
    `$ docker logs -f oracdb`  
    로그에서 Done! The data base is ready for use 확인

    - Oracle 접속 확인
    `$ docker exec -it oradb bash -c "source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLCDB as sysdba"`

-----
ref: https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g  
```  
docker run -d -p 49161:1521 -e ORACLE_ALLOW_REMOTE=true --name oradb oracleinanutshell/oracle-xe-11g
```  
````  
By default, the password verification is disable(password never expired)
Connect database with following setting:

hostname: localhost
port: 49161
sid: xe
db: xe
username: system
password: oracle


sqlplus sys/oracle@xe as sysdba
```  


    2.3 sample user 및 table 생성  
    ``` 
    $ podman cp scott.sql  oradb:/   
    $ podman exec -it oradb bash  
    $ ls  
    $ sqlplus / as sysdba 
    SQL> alter session set "_ORACLE_SCRIPT"=true;  # 12c의 경우.
    SQL> @scott.sql  
    SQL> conn scott/tiger  
    SQL> select table_name from user_tables;  
    ```

    2.4 sqlplus TIP (sqlplus / as sysdba)  
    - database name 확인  
      SQL> select name, db_unique_name from v$database;  
    - sid 확인  
      SQL> select instance from v$thread