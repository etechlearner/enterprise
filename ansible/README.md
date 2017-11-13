## Deployment Overview

This repository contains all of the necessary automation scripts and
logic required to setup a production-ready instance of Stoplight
Enterprise v3 leveraging [Ansible](https://www.ansible.com/), a
configuration management toolkit. Prior experience with Ansible is not
required, and Stoplight engineers are at your disposal if you have any
questions regarding the setup process.

## Deployment Options

Before beginning with the installation, be sure to prepare all of the
necessary systems that will be running Stoplight components. For more
information on sizing, disk, and network requirements, please see the
readme [here](/README.md).

There are currently two separate deployment options, each described
below.

### Single-Machine Deployments

Single-machine deployments run all of the necessary Stoplight
components on a single Linux instance. This greatly simplifies the
deployment process, as all components do not have to reach over the
network to talk to eachother, however there are some notable
shortcomings to this option:

* If the system is taken down for any reason, all components will be
  unavailable. In a distributed deployment (described below), losing a
  single instance will typically allow other parts of the Stoplight
  Enterprise platform to continue functioning.

* Any single component can affect the performance of the entire
  Stoplight platform, leading to service degradation across all
  components. This issue can be mitigated using Docker runtime
  restrictions and other similar system-level settings, however it is
  worth mentioning if your organization relies heavily on long-running
  scenarios or heavily-referenced specs.

Due to the shortcomings listed above, this option is typically
recommended for POC/trial environments or smaller organizations that
do not wish to allocate multiple instances for the Stoplight platform.

### Multi-machine Deployments

Multi-machine deployments run different Stoplight Enterprise
components on separate Linux instances. This deployment option is much
more resilient to system failure, however it does require more
machines to run and more work to configure the network so that all
instances can communicate properly.

Stoplight recommends multi-machine deployments for most production
environments.

## Running Ansible

For users unfamiliar with Ansible, Stoplight recommends using the
Ansible docker container available from the Stoplight Docker
repository. The machine running Ansible (typically your personal
workstation or a bastion host) will need to have:

* SSH connectivity to all machines in the deployment environment

* User access with administrative privileges (ie, capable of running
  `sudo` commands)

> Password-less key-based authentication is recommended for ease of
use, however it is not a requirement.

### Required Variables

Before running the Ansible scripts to deploy Stoplight, you will need
to set custom variables based on your environment:

```yaml
# environment name
app_environment: production
# whether ssl should be enabled
global_ssl_enabled: no

# hostname information
sl_app_hostname: stoplight.example.com
sl_api_hostname: stoplight-api.example.com
sl_exporter_hostname: stoplight-exporter.example.com
prism_hostname: stoplight-prism.example.com
postgresql_hostname: stoplight-postgresql.example.com
gitlab_hostname: stoplight-gitlab.example.com

# data location
gitlab_data_dir: /data/gitlab-data
postgresql_data_dir: /data/pgdata

# database credentials
postgresql_user: stoplight
postgresql_database: stoplight
postgresql_password: supersecretpassword
```

Where the variables above are:

* `app_environment` - A label to apply to the environment (for
  example, "production", "pilot", etc). This is only used for metadata
  purposes, and does not otherwise effect the deployment of Stoplight.

* `docker_login` - Docker username to use when authenticating with the
  Stoplight container registry. This should be provided to you by
  Stoplight.

* `docker_password` - Docker password to use when authenticating with
  the Stoplight container registry. This should be provided to you by
  Stoplight.

* `sl_app_hostname` - The hostname where the Stoplight application
  will be served from. This is where end-users will go to interact
  with the Stoplight UI, so it must be resolvable by DNS.

* `sl_api_hostname` - The hostname where the Stoplight backend API
  will be served from. This hostname must be resolvable by end-users
  (through AJAX requests) as well as the Stoplight frontend
  application above.

* `sl_exporter_hostname` - The hostname where the Stoplight exporter
  will be served from. The exporter dereferences and resolves
  specifications, so it must be able to talk to all components of the
  Stoplight application stack.

* `prism_hostname` - The hostname where
  [Prism](http://stoplight.io/platform/prism/) will be served
  from. Similar to the exporter above, this host must be resolvable by
  all components of the Stoplight stack (and sometimes end-user and CI
  systems).

* `gitlab_hostname` - The DNS hostname used to reach the Gitlab
  instance. This hostname must be resolvable by the Stoplight API,
  either via DNS or `/etc/hosts` setting.

* `postgresql_hostname` - The DNS hostname used for the PostgreSQL
  server. If you are using an external PostgreSQL instance, this will
  be the hostname or IP of that instance. This host must be resolvable
  by both Gitlab and the Stoplight API.

* `gitlab_data_dir` - The filesystem location to store Stoplight git
  data. __This directory should be backed up on a regular basis and
  stored on redundant storage if possible.__

* `postgresql_data_dir` - The filesystem location to PostgreSQL
  data. __This directory should be backed up on a regular basis and
  stored on redundant storage if possible.__

* `postgresql_user` - The user to connect to PostgreSQL as.

* `postgresql_password` - The password used to connect to PostgreSQL.

* `postgresql_database` - The database to connect to.

To set the variables above, create either a YAML or JSON formatted
text file under the `/vars` directory of this repository with the
variable names and their corresponding values. This file will need to
be referenced later when running the `run-ansible.sh` script.

> There is a demo variable file at [`/vars/demo.yml`](/vars/demo.yml)
  that can be used as reference for building out your variables file.

### Downloading Ansible

If you are already familiar with how to run Ansible playbooks, then
you can continue to the next section.

To pull the official Stoplight Ansible container, please run:

```
docker pull quay.io/stoplight/ansible:latest
```

When the image has downloaded, you can use the
[`run-ansible.sh`](/run-ansible.sh) helper script included in this
repository to kick off an Ansible playbook against a set of target
instances.

### Creating an Inventory

An "inventory" file is a file listing out the different hosts to
target for a deployment. When deploying Stoplight, an inventory must
have the following sections:

* `gitlab`
* `api`
* `app`
* `exporter`
* `prism`

Each section above corresponds to a component of the Stoplight
Enterprise platform.

As an example, here is a demo inventory showing the correct format:

```
[gitlab]
123.45.6.02

[api]
123.45.6.02

[app]
123.45.6.03

[exporter]
123.45.6.04

[prism]
123.45.6.05
```

> Please note that the same IP/hostname can be used under multiple
  sections to allocate multiple components to the same machine.

Using the example above, the machine-to-component mapping will look
similar to:

* Machine `123.45.6.02` will host Gitlab and the API
* Machine `123.45.6.03` will host the App
* Machine `123.45.6.04` will host the Exporter
* Machine `123.45.6.05` will host Prism

## Running the Deployment

Once Ansible has been configured properly (the inventory and variable
files are created, and you have verified you can SSH to every machine
referenced in the inventory), you should be ready to deploy Stoplight
Enterprise.

Included in the `/playbooks` directory is an `install.yml` file that
will perform all of the necessary steps required to setup a
production-ready Ansible installation. To run the `install.yml`
playbook as the `root` user, use the command:

```
$ ./run-ansible.sh myvars.yml myhosts.inv install.yml root
```

Where:

* `myvars.yml` is the variable file created with your environment
  parameters.

* `myhosts.inv` is the inventory with the hostnames or IP addresses of
  every instance in the deployment.

* `install.yml` is the playbook we are going to run, which will
  install all Stoplight components.

* `root` is the user to login as.

Using the command above, the playbook will be running successfully
when you see output similar to the following:

```
$ ./run-ansible.sh myvars.yml myhosts.inv install.yml root

PLAY [all] *********************************************************************

TASK [setup] *******************************************************************
ok: [123.45.6.02]
ok: [123.45.6.03]
ok: [123.45.6.04]
ok: [123.45.6.05]

...
```

Where an `ok` is listed under `setup`, with all machines in your
inventory. This signifies Ansible was successfully able to connect to
each machine in your inventory. If you do not see output similar to
the above, or an error is printed, please contact Stoplight support
for assistance.

### Verifying the Deployment

To verify that Stoplight Enterprise was installed correctly, you can
visit the `sl_app_hostname` variable that was set above in a web
browser. If everything is working properly, you should be greeted with
a login screen similar to what you would see in the [hosted version of
Stoplight](https://next.stoplight.io/login).

#### Post-installation Steps

Once Stoplight Enterprise has been installed, there are a few
post-install steps that should be taken to ensure the security of the
application.

##### Changing the Gitlab Administrative Password

Login to Gitlab (using the `gitlab_hostname` variable set above) with the following credentials:

* username: `root`
* password: `eiyaes5eeJudae9iecei0air`

> The password above assumes the default value for the
  `gitlab_root_password` variable was used. If you set a custom
  password, then this step can be skipped.

### Getting Help

For help with an on-premise deployment (from setup to maintenance),
please contact Stoplight support at
[support@stoplight.io](mailto:support@stoplight.io).
