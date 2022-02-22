1. Subscription  등록 및 enable  
   - 전체 repository 등록  
    $ subscription-manager register --auto-attach  
    username, password  입력  

    - JBCS Apache HTTP  Server enable  
    $ subscription-manager repos --enable=jb-coreservices-1-for-rhel-8-x86_64-rpms

2. Install
   - jbcs core service install
    JBCS modules are located in /opt/rh/jbcs/root/usr/lib64/httpd/modules  
    $ yum group install jbcs-httpd24  
   - install httpd and modules
    $ yum install httpd 
    (Optional for RHEL 8: same module loacated in /opt/lib64/httpd/modules directory)   
    $ dnf install apr apr-util     










