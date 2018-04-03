#!/bin/bash
umask 0022
echo "Umask is set to 0022"
echo "Acquiring packages to install"
wget -b -c http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz
echo "Packages acquired successfully"
echo "Extracting the package"
tar  xzf hadoop-2.7.5.tar.gz
echo "Extraction successful"
echo "Moving files to install location: /usr/local/hadoop"
sudo mkdir -p /usr/local/hadoop
sudo mv ./hadoop-2.7.5/* /usr/local/hadoop
echo "Move successful"
echo "Changing Permissions"
sudo chown -R hpc:hpc /usr/local/hadoop
echo "Configuring Installation"
sudo echo "#HADOOP VARIABLES START" >> ~/.bashrc
sudo echo "export JAVA_HOME=/usr" >> ~/.bashrc
#sudo echo "export PATH=\$PATH:\$JAVA_HOME" >> ~/.bashrc
sudo echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
sudo echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >> ~/.bashrc
sudo echo "export PATH=\$PATH:\$HADOOP_HOME/sbin" >> ~/.bashrc
sudo echo "#HADOOP VARIABLES END" >> ~/.bashrc
source ~/.bashrc
echo "Installing XMLStarlet"
sudo apt-get install xmlstarlet
echo "Install XMLStarlet Complete"
xmlstarlet ed --inplace -s /configuration -t elem -n property -v "" -s /configuration/property -t elem -n name -v fs.defaultFS -s /configuration/property -t elem -n value -v hdfs://localhost:9000 $HADOOP_HOME/etc/hadoop/core-site.xml
echo "core-site.xml configured"
xmlstarlet ed --inplace -s /configuration -t elem -n property -v "" -s /configuration/property -t elem -n name -v dfs.replication -s /configuration/property -t elem -n value -v 1 $HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo "hdfs-site.xml configured"
echo "Configuration complete"
echo "Install complete"
echo "Checking passwordless ssh"
ssh -o 'PreferredAuthentications=publickey' localhost "echo"
if [ $? -eq 0 ];
then
	echo "Passwordless ssh is already enabled" 
	echo "Starting HDFS"
	hdfs namenode -format -y
	start-dfs.sh

else
	echo "Cannot ssh to localhost without passphrase. Establish passwordless ssh and then start hdfs"
fi
