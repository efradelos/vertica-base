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

