#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/setup.sh"

setup_env
yum update -y 

yum install gdb -y
yum install mcelog -y
yum install sysstat -y
yum install jq -y


# See https://www.vertica.com/docs/10.0.x/HTML/Content/Authoring/InstallationGuide/AppendixTimeZones/UsingTimeZonesWithVertica.htm
timedatectl set-timezone America/Chicago
echo "export TZ=America/Chicago" >> /home/$db_user/.bashrc

# See https://www.vertica.com/docs/10.0.x/HTML/Content/Authoring/InstallationGuide/BeforeYouInstall/DiskReadahead.htm
/sbin/blockdev --setra 2048 /dev/nvme0n1p1
echo '/sbin/blockdev --setra 2048 /dev/nvme0n1p1' >> /etc/rc.local
