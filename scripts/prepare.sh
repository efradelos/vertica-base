#!/bin/bash
yum update -y 
yum install -y gdb
yum install -y mcelog
yum install -y sysstat

/sbin/blockdev --setra 2048 /dev/nvme0n1p1
echo '/sbin/blockdev --setra 2048 /dev/nvme0n1p1' >> /etc/rc.local

cat << EOF | su - ${user}
    echo "export TZ='America/Chicago'" >> ~/.bashrc
EOF


# dd if=/dev/zero of=/swapfile bs=128M count=32
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile
# echo '/swapfile swap swap defaults 0 0' >> /etc/fstab


# /sbin/blockdev --setra 2048 /dev/nvme0n1p1
# echo '/sbin/blockdev --setra 2048 /dev/nvme0n1p1' >> /etc/rc.local

# echo 'deadline' > /sys/block/nvme1n1/queue/scheduler
# echo 'echo deadline > /sys/block/nvme1n1/queue/scheduler' >> /etc/rc.local

# cat << EOF >> /etc/rc.local
# if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
#     echo always > /sys/kernel/mm/transparent_hugepage/enabled
# fi
# EOF
# echo 'always' > /sys/kernel/mm/transparent_hugepage/enabled


# echo 'vm.swappiness = 1' >> /etc/sysctl.conf
# echo 1 > /proc/sys/vm/swappiness


# groupadd verticadba
# usermod -g verticadba ec2-user

# export TZ='America/Chicago'
# echo "export TZ='America/Chicago'" >> ~/.bash_profile
# sudo yum localinstall -y vertica-10.0.0-0.x86_64.RHEL6.rpm
# sudo /opt/vertica/sbin/install_vertica -u ec2-user -s 172.30.101.77,172.30.101.148,172.30.101.245 -r vertica-10.0.0-0.x86_64.RHEL6.rpm -Y --clean
# sudo /opt/vertica/sbin/install_vertica -u ec2-user -s localhost -r vertica-10.0.0-0.x86_64.RHEL6.rpm -Y --clean



# ip-172-30-101-77.ec2.internal
# /usr/bin/env VERT_DBA_USR=ec2-user VERT_DBA_GRP=verticadba VERT_DBA_HOME=/home/ec2-user VERT_DBA_DATA_DIR=/vertica/data /opt/vertica/oss/python3/bin/python3 -m vertica.local_coerce
# sudo /opt/vertica/sbin/install_vertica -i .ssh/id_rsa -s 172.30.101.34,172.30.101.123,172.30.101.178 -Y
# 