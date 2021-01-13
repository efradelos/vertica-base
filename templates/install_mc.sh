#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/setup.sh"


function main () {
    echo "[Install Management Console] Starting..."
    setup_env
    
    echo "[Install Management Console] Getting Secrets"
    get_secrets

    echo "[Install Management Console] Waiting for Cluster"
    wait_for_cluster

    echo "[Install Management Console] Running Install Script"
    /var/opt/vconsole/install_mc.sh

    echo "[Install Management Console] Retrieve SSH keys from nodes"
    retrieve_ssh_keys_from_primary

    echo "[Install Management Console] Configure Cluster in Console"
    configure_cluster

}

function wait_for_cluster () {
    local node_ip=`get_instance_metadata ${node_ids[0]} "PrivateIpAddress"`

    while ! nc -z $node_ip 5433; do 
        sleep 5
    done
}

#######################################
# Transfer ssh keys needed by vertica passworless 
# ssh to host node
# ARGUMENTS:
#   - name or ip address of host 
#######################################
function retrieve_ssh_keys_from_primary () {
    local instance_id=${node_ids[0]}
    local host=`get_instance_metadata $instance_id "PrivateIpAddress"`

    ssh-keyscan $host >> ~/.ssh/known_hosts

    keypath=`mktemp -d`
    ssh-keygen -t rsa -f $keypath/key  -q -N ""

    (sleep 60; rm -rf $keypath)&

    aws ec2-instance-connect send-ssh-public-key \
        --instance-id $instance_id \
        --availability-zone $availability_zone \
        --instance-os-user $db_user \
        --ssh-public-key file://$keypath/key.pub

    scp -i $keypath/key -r ${db_user}@${host}:.ssh /home/$db_user/.
    chown $db_user:verticadba /home/$db_user/.ssh/*
}

function configure_cluster () {
    local instance_id=${node_ids[0]}
    local host=`get_instance_metadata $instance_id "PrivateIpAddress"`

    echo 'cloud.authentication=IAM' >> /opt/vconsole/config/console.properties
    echo 'provisioning.service.enabled=true' >> /opt/vconsole/config/console.properties

    (cd /var/opt/vconsole; ./mc_config.sh $mc_username $secret_mc_password $host $db_name $db_user $secret_db_password)
}

main