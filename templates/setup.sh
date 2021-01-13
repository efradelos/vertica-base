#!/bin/bash

function get_metadata () {
    jq -r $1 /run/cloud-init/instance-data-sensitive.json
}

#######################################
# Get metadata for a particular instance
# ARGUMENTS
# - instance id for which to grab metadata
# - query for metadata to return 
# OUTPUTS
#   Writes the metadata requested to stdout
#######################################
function get_instance_metadata () {
    local instance_id=$1
    local query=$2

    aws ec2 describe-instances \
        --instance-ids $instance_id \
        --query "Reservations[].Instances[].$query" \
        --output text
}

#######################################
# Gets secrets passed in by configuration
# GLOBALS
#   secret_<SECRET NAME> = <SECRET_VALUE>
#######################################
function get_secrets () {
    local secrets_json=`
        aws secretsmanager get-secret-value \
            --secret-id $credentials_secret_id \
            --query SecretString \
            --output text`

    for s in `echo $secrets_json | jq -r 'to_entries[] | ["secret_" + .key,.value] | join("=")'`; do
        export $s
    done    
}

#######################################
# Join bash array by passed in string
# ARGUMENT
#   - string to join array by
#######################################
function join { local d=$1; shift; local f=$1; shift; printf %s "$f" "$${@/#/$d}"; }

#######################################
# Setup global variables based on 
# configuration
#######################################
function setup_env () {
    mc_name="${mc_name}"
    mc_username="${mc_username}"
    node_prefix="${node_prefix}"
    node_count="${node_count}"
    credentials_secret_id="${credentials_secret_id}"
    db_user="${db_user}"
    db_name="${db_name}"
    db_data_dir="${db_data_dir}"
    db_license_base64="${db_license_base64}"
    db_shard_count="${db_shard_count}"
    db_communal_storage="${db_communal_storage}"
    db_depot_path="${db_depot_path}"    

    region=`get_metadata .v1.region`
    availability_zone=`get_metadata .v1.availability_zone`

    aws configure set region $region
    node_ids=(`aws ec2 describe-instances \
        --filters \
            Name=tag:Name,Values=$node_prefix-* \
            Name=instance-state-name,Values=running \
        --query "Reservations[].Instances[].InstanceId" \
        --output text`)
}
