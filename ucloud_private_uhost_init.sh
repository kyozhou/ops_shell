#!/bin/bash

echo 'Install basic software'
yum -y install epel-release
yum makecache
yum -y install mosh wget telnet lsof vim unzip zip gcc-c++ gcc yum-utils ntpdate

#内网访问外网（有公网IP忽略）
echo -n 'Input Gateway IP:'
read gateway
sed -i "s/.*GATEWAY.*/GATEWAY=$gateway/" /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart

echo -n "Input Hostname:"
read hostname
if [ "`grep $hostname '/etc/hosts'`" = "" ]; then
    echo "127.0.0.1 $(hostname)" >> /etc/hosts
    echo "HOSTNAME=$(hostname)" >> /etc/sysconfig/network
    hostnamectl --static set-hostname $hostname
fi

echo 'Input id_rsa.pub of jump server:'
read authorized_keys
if [ ! -d  "/root/.ssh" ]; then
    mkdir "/root/.ssh"
fi
echo $authorized_keys > /root/.ssh/authorized_keys

echo "Disable selinux"
sed -i 's/\s*SELINUX\=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo "Auto ajust time"
crontab_file="crontab_$RANDOM.cmd"
echo "30 * * * * ntpdate -u cn.ntp.org.cn" > $crontab_file
crontab $crontab_file
rm $crontab_file

echo "Finished"
