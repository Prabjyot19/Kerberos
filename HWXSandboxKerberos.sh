#!/bin/bash                                                                                                                                 
                                                                                                                                            
#To use this script directly in the Hortonworks Sandbox I use this command                                                                  
#wget https://gist.github.com/jdye64/76d4dc92018c3e613f66/download -O hwx_sand_krb.tar.gz && tar zxvf ./hwx_sand_krb.tar.gz -C ./. --strip-c
omponents=1 && chmod 777 ./HWXSandboxKerberos.sh && ./HWXSandboxKerberos.sh                                                                 
                                                                                                                                            
#Case sensitive. This will bite you if not careful                                                                                          
#KDC Host - sandbox.hortonworks.com                                                                                                         
#Realm Name - HORTONWORKS.COM                                                                                                               
#Domains - .hortonworks.com,hortonworks.com                                                                                                 
#kadmin host - sandbox.hortonworks.com                                                                                                      
#admin principal - root/admin                                                                                                               
#admin password - hadoop                                                                                                                    
                                                                                                                                            
echo "Preparing Hortonworks Sandbox for Kerberos environment"                                                                               
sudo yum install krb5-libs krb5-server krb5-workstation -y                                                                                  
echo "Kerberos components installed"                                                                                                        
                                                                                                                                            
#THIS SHOULD NEVER BE USED OUTSIDE OF SANDBOX IN PRODUCTION ENVIRONMENTS! You have been warned                                              
                                                                                                                                            
#Prepare the configuration files with some defaults values.                                                                                 
echo "Configuring /etc/krb5.conf file for sandbox"                                                                                          
sed -i 's/EXAMPLE.COM/HORTONWORKS.COM/g' /etc/krb5.conf                                                                                     
sed -i 's/example.com/hortonworks.com/g' /etc/krb5.conf                                                                                     
sed -i 's/kerberos.hortonworks.com/sandbox.hortonworks.com/g' /etc/krb5.conf                                                                
                                                                                                                                            
echo "Configuring /var/kerberos/krb5kdc/kdc.conf file for sandbox"                                                                          
sed -i 's/EXAMPLE.COM/HORTONWORKS.COM/g' /var/kerberos/krb5kdc/kdc.conf                                                                     
                                                                                                                                            
echo "Configuring /var/kerberos/krb5kdc/kadm5.acl file for sandbox"                                                                         
sed -i 's/EXAMPLE.COM/HORTONWORKS.COM/g' /var/kerberos/krb5kdc/kadm5.acl                                                                    
                                                                                                                                            
#Use the default password of hadoop since that is the default root for the sandbox                                                          
echo "Creating KDC DB with master password - 'hadoop'"                                                                                      
yes hadoop | kdb5_util create -s                                                                                                            
echo "KDC DB created"                                                                                                                       
                                                                                                                                            
echo "Creating kadmin admin user 'root/admin' with password 'hadoop'"                                                                       
yes hadoop | kadmin.local -q "addprinc root/admin"                                                                                          
                                                                                                                                            
echo "chkconfig ON Kerberos services"                                                                                                       
chkconfig krb5kdc on                                                                                                                        
chkconfig kadmin on                                                                                                                         
                                                                                                                                            
echo "Starting Kerberos service"                                                                                                            
service krb5kdc start                                                                                                                       
service kadmin start                                                                                                                        
echo "Kerberos services started"                                                                                                            
echo "Kerberos sandbox configuration complete. Please navigate to Ambari server to complete kerberos for HDP Sandbox installation"
