#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/setup.sh"

ORGNAME="Vertica PoC Family"
ORGUNIT="Vertica PoC Certificate Authority"
LOCALITY="Wildwood"
STATE="MO"
COUNTRY="US"

function main () {
    echo "[Configure Vertica TLS] Starting..."
    setup_env
    tmp=`mktemp -d`

    echo "[Configure Vertica TLS] Getting Secrets"
    get_secrets

    echo "[Configure Vertica TLS] Generating Root Certificate"
    generate_root_cert $tmp/root

    echo "[Configure Vertica TLS] Generating Server Certificate for clients"
    generate_cert $tmp/server vertica.poc

    echo "[Configure Vertica TLS] Generating Server Certificate for cluster"
    generate_cert $tmp/internode vertica.poc
    # generate_cert $tmp/client vertica.poc

    chown -R $db_user $tmp

    echo "[Configure Vertica TLS] Enable TLS for clients"
    enable_tls $tmp/server.crt $tmp/server.key

    echo "[Configure Vertica TLS] Enable TLS for cluster"
    enable_internode_tls $tmp/internode.crt $tmp/internode.key $tmp/root.crt 

    rm -f $tmp/*
    echo "[Configure Vertica TLS] Finished"
}


#######################################
# Generate a root certificate and private key
# ARGUMENTS
# - name of the cert and private key to create
#######################################
function generate_root_cert () {
    cert_name=$1

    openssl req -new -x509 \
        -nodes  \
        -days 365 \
        -keyout $cert_name.key \
        -subj "/CN=Vertica PoC Root CA/O=$ORGNAME/OU=$ORGUNIT/L=$LOCALITY/ST=$STATE/C=$COUNTRY" \
        -out $cert_name.crt 

    chmod 600 $cert_name.*
}

#######################################
# Generate a certificate and private key
# signed by a root certificate
# ARGUMENTS
# - name of the cert and private key to create
# - fully qualified domain name of cert to create
# - the root certificate used to sign.  Defaults 
#   to 'root.crt' within same directory
#######################################
function generate_cert () {
    cert_name=$1
    FQDN=$2
    root=${3:-`dirname $cert_name`/root}

    openssl genrsa -out $cert_name.key 2048

    openssl req -new \
        -key $cert_name.key \
        -subj "/CN=$FQDN/O=$ORGNAME/OU=$ORGUNIT/L=$LOCALITY/ST=$STATE/C=$COUNTRY" \
        -out $cert_name.csr

    openssl x509 \
        -req -in $cert_name.csr \
        -CA $root.crt \
        -CAkey $root.key \
        -CAcreateserial \
        -days 365 \
        -out $cert_name.crt

    chmod 600 $cert_name.*
}

function stop_db () {
    sudo -u $db_user /opt/vertica/bin/adminTools --tool stop_db \
        --database $db_name \
        --password $secret_db_password \
        -F
}

function start_db () {
    sudo -u $db_user /opt/vertica/bin/adminTools --tool start_db \
        --database $db_name \
        --password $secret_db_password
}

function restart_db () {
    stop_db
    start_db
}

#######################################
# Enables TLS in vertica cluster
# See https://www.vertica.com/docs/10.0.x/HTML/Content/Authoring/Security/ClientAuth/ConfiguringTLSAuthentication.htm
# ARGUMENTS
# - path of server certificate
# - path of server private key file
# - the root certificate if using 
#   mutual mode
#######################################
function enable_tls () {
    ssl_cert_file=$1
    ssl_key_file=$2
    # ssl_ca_file=$3

    sudo -u $db_user /opt/vertica/bin/admintools \
        --tool set_ssl_params \
        --database "$db_name" \
        --password "$secret_db_password" \
        --ssl-key-file $ssl_key_file \
        --ssl-cert-file $ssl_cert_file 
        # -ssl-ca-file $ssl_ca_file

    echo "ALTER DATABASE $db_name SET EnableSSL = 1;" | /opt/vertica/bin/vsql -U $db_user -w $secret_db_password
}

#######################################
# Enables internode TLS in vertica cluster
# See https://www.vertica.com/docs/10.0.x/HTML/Content/Authoring/Security/TLS/InternodeTLS.htm
# ARGUMENTS
# - path of server certificate
# - path of server private key
# - path of the root certificate 
#######################################
function enable_internode_tls () {
    ssl_cert_file=$1
    ssl_key_file=$2
    ssl_ca_file=$3
    
    ssl="$(cat $ssl_cert_file),$(cat $ssl_key_file),$(cat $ssl_ca_file)"
    echo "ALTER DATABASE $db_name SET EncryptSpreadComm = 'vertica';" | /opt/vertica/bin/vsql -U $db_user -w $secret_db_password

    restart_db
    echo "ALTER DATABASE $db_name SET DataSSLParams = '$ssl'" | /opt/vertica/bin/vsql -U $db_user -w $secret_db_password
    restart_db
}

main


