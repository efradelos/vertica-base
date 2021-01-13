# Getting Started

## Preparing for Install

This module assumes a Virtual Private Cloud (VPC) with a public and private subne has already been created and deployed by Cloud Services, The variables below describing the network are requiured.

> **vpc_id**: ID of VPC to install vertica cluster

> **public_subnet_id**: ID of public subnet to install vertica cluster. Management Console will (optionally) be deployed here.

> **private_subnet_id**: ID of private subnet to install vertica cluster. Nodes that make up cluster will be placed here.

> **credentials_secret_id**: Name or ID of AWS secret used to retrieve credentials for database admin password (db_password) and management console admin password (mc_admin)

## Configure Vertica Cluster

### SSH Key

An AWS key pair is needed to allow for ssh access into cluster. The key pair can either be created offline in AWS or created and imported using this module.

> **create_ssh_key**: Determines if AWS key pair is created or if an extisting key pair is to be used

> **ssh_key_name**: Name of new key pair or name of existing key pair to use depending on _create_ssh_key_

> **ssh_key_path**: Path of public key to use for key pair (i.e. secrets/vertica*key.pub). Only used if \_create_ssh_key* is true.

To create key, use the following command:

```bash
# Create Key
$ ssh-keygen -t rsa -f secrets/vertica_key  -q -N ""
```

### Security Group

An AWS security group is needed to control network access to cluster. The securty group created by this module allow all outbound access, all inbound access from instances within cluster, and then all access from rga networks for ssh (port 22), vertica database (port 5433) and vertica management console (port 5450). All other access is blocked. For more information on ports needed by vertica, see [documentation](https://www.vertica.com/docs/10.0.x/HTML/Content/Authoring/InstallationGuide/BeforeYouInstall/PortAvailability.htm)

> **create_security_group**: Determines if AWS security group is created by this module or if an existing group is to be used.

> **security_group_name**: Name of new security group or name of existing group to use depending on _create_security_group_

> **rga_networks**: a list of cidr blocks that are allowed access to public facing services (i.e. ssh, vsql, management console)

### Instance Profile

Each instance within cluster are setup with an instance profile that has policies to limit access to only the resources needed. For example, all nodes are given read/write access to s3 bucket used for communal storage that is specified in configuration. See `policies.tf` for more details on permissions granted to instances.

> **create_instance_profile**: Determines if instance profile should be created

> **instance_profile_name**: Name of new instance profile or name of existing instance profile to use depending on _create_instance_profile_

### Communal Storage

An S3 bucket is needed if using Vertica in EON Mode. The S3 bucket created by this module use server side encryption and block all public access.

> **create_communal_storage_bucket**: Determines if S3 bucket should be created for communal storage (EON Mode only)

### Nodes

Nodes in the cluster are configured by the following database.

> **node_count**: Number of nodes to create for cluster (default 3)

> **node_prefix**: Prefix to use for node names. i.e. `vertica-node` will translate to nodes having names `vertica-node-1`, `vertica-node-2`, etc

> **node_ami**: AMI to use for each node in cluster. Default AMI is provided by Vertica that includes version 10.0. This can be used for versioning

> **node_instance_type**: Instance type to use for each node in cluster (default: c5.large)

### Database Properties

> **dba_user**: The name of db admin account (default: `dbadmin`)

> **db_name**: The name of the database (default: `db1`)

> **db_data_dir**: Specify the directory for database data and catalog files (default: `/vertica/data`)

> **db_eon_mode**: Should use EON mode for database (default: `true`)

> **db_communal_storage_bucket**: Name of S3 bucket used for communalstorage (EON Mode only, default: `vertica-communal-storage`)

> **db_communal_storage_key**: Key for S3 bucket communal storage data (EONMode only, default: `data`)

> **db_shard_count**: Shard count for database. (EON Mode only, default: `6`)

> **db_license_base64**: The license to use for cluster in base64 format (default: `Community Edition`)

> **db_depot_path**: Path to depot directory. (EON Mode only, default: `/vertica/data`)

### Load Balancer

### Management Console

### Monitoring (Cloud Watch)

# Contributing

See [Contributing](./CONTRIBUTING.md)
