# Single node Hadoop install and configuration script for Ubuntu 
 Use only with Ubuntu Xenial

 Make sure Java is installed and JAVA_HOME is set in /etc/environment as /usr. Check it by typing "echo $JAVA_HOME" in terminal.

 Make sure Passwordless ssh is established on your system. Do ssh localhost to check.
 
 if it asks for password, run following commands: 
 
 sudo ssh-keygen
 
 ssh-copy-id localhost

 Then only run the script
