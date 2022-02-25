  ### RHEL8 Subscription  등록 및 enable  
   - 전체 repository 등록  
    $ subscription-manager register --auto-attach  
    username, password  입력  

    - JBCS Apache HTTP  Server enable  
    $ subscription-manager repos --enable=jb-coreservices-1-for-rhel-8-x86_64-rpms  

1. Install
   As the root user:
   1.1 Using ZIP Archive  
   - prereq  
   $ yum install --enablerepo=powertools elinks -y  
   $ yum install -y  krb5-workstation mailcap  

   download info: https://access.redhat.com/solutions/4368491  
   Windows으로 downlaod해서 copy  

   - unzip  
   $ unzip jbcs-httpd24-httpd-2.4.37-SP6-RHEL8-x86_64.zip -d /opt  
   export HTTPD_HOME=/opt/jbcs-httpd24-2.4/httpd
   
   1.2 사용자 및 그룹 추가  
   $ groupadd -g 48 -r apache  
   $ useradd -c "Apache" -u 48 -g apache -s /bin/sh -r apache   
   $ cd /opt/jbcs-httpd24-2.4/httpd  
   $ chown -R apache:apache *  

   1.3 Running the Apache HTTP Server Post-Installation Script
   $ cd /opt/jbcs-httpd24-2.4/httpd
   $ ./.postinstall  

   1.4 Stop & Start Apache HTTPD Server
   $ $HTTPD_HOME/sbin/apachectl start
   $ $HTTPD_HOME/sbin/apachectl stop
   








