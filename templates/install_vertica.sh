#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/setup.sh"

my_id=`get_metadata .v1.instance_id`

function main () {
    echo "[Install Vertica] Starting..."
    setup_env 

    echo "[Install Vertica] Getting Secrets"
    get_secrets

    echo "[Install Vertica] Generating SSH key for cluster"
    generate_cluster_ssh_key

    echo "[Install Vertica] Transfering SSH key to all nodes"
    for node_id in ${node_ids[@]}; do
        if [[ "$node_id" != "$my_id" ]]; then
            # wait_for_node $node_id
            transfer_ssh_keys_to_node $node_id
        fi
    done

    echo "[Install Vertica] Running Vertica Install"
    install_vertica 

    echo "[Install Vertica] Creating Database"
    create_database

    echo "[Install Vertica] Finished"
}
       

#######################################
# Generate SSH key, and add to authorized keys to
# allow passwordless ssh required by vertica tools
#######################################
function generate_cluster_ssh_key () {
  sudo -u $db_user -- ssh-keygen -t rsa -b 2048 -f /home/$db_user/.ssh/id_rsa -q -N ""
  cat /home/$db_user/.ssh/id_rsa.pub >> /home/$db_user/.ssh/authorized_keys
}


#######################################
# Wait for node to become available 
# ARGUMENTS:
#   - instance id of node to transfer keys
#######################################
function wait_for_node () {
    local instance_id=$1

    cmd="aws ec2 describe-instance-status --instance-id $instance_id --query InstanceStatuses[].SystemStatus.Status --output text"
   
    while [[ `$cmd` != "ok" ]]; do 
        sleep 5
    done
}


#######################################
# Transfer ssh keys needed by vertica 
# passworless ssh to host node
# ARGUMENTS:
#   - instance id of node to transfer keys
#######################################
function transfer_ssh_keys_to_node () {
    local instance_id=$1
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

    scp -i $keypath/key -r /home/$db_user/.ssh $db_user@$host:.
}


#######################################
# Installs vertica to all hosts
#######################################
function install_vertica () {
    local hosts=()
    local license="$(mktemp)"

    echo "$db_license_base64" | base64 -d > $license

    for node_id in ${node_ids[@]}; do
        hosts+=(`get_instance_metadata $node_id "PrivateIpAddress"`)
    done
  
    sudo -u $db_user -- sudo /opt/vertica/sbin/install_vertica \
        --accept-eula \
        --hosts `join "," ${hosts[@]}` \
        --data-dir $db_data_dir \
        --dba-user $db_user \
        --ssh-identity /home/$db_user/.ssh/id_rsa \
        --license $license
}


#######################################
# Creates database on vertica cluster 
# using configuration options provided
#######################################
function create_database () {
    local hosts=()

    for node_id in ${node_ids[@]}; do
        hosts+=(`get_instance_metadata $node_id "PrivateIpAddress"`)
    done

    sudo -u $db_user -- /opt/vertica/bin/admintools \
        --tool create_db \
        --database "$db_name" \
        --password "$secret_db_password" \
        --hosts `join "," ${hosts[@]}` \
        --shard-count $db_shard_count \
        --communal-storage-location "$db_communal_storage" \
        --depot-path "$db_depot_path"
}

main
