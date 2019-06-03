---
layout: default
title: Frontend
nav_order: 5
parent: Installation
permalink: design-manager/installation/frontend
nav_no_fold: true
---

# Installing the Frontend

The **frontend** component is the Stoplight user-interface.

#### Networking Details

The default port for this component is TCP port **`4050`**. The port can be
customized using the `PORT` configuration variable.

This component must be able to receive **incoming** connections from the following components:

- Clients (ie, web browsers or Stoplight Studio instances)

This component must be able to make outgoing connections to the following
components:

- Backend

#### Component Dependencies

Make sure the following components are available **before** starting this component:

- Backend

## RPM Installation

Prior to installing the RPM package, you will need to:

- Install NodeJS v10.x

- Have the Stoplight package repository installed and configured with your user-specific credentials

#### Installing NodeJS

If you do not have access to a NodeJS package in your default repositories, run the command:

```bash
sudo rpm -Uvh https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodejs-10.16.0-1nodesource.x86_64.rpm
```

Once the installation has completed, verify the version installed with the command:

```bash
$ node --version
v10.16.0
```

If you do not see a version starting `v10.16.0`, contact Stoplight support for assistance.

#### Setting up the Package Repository

You can setup the Stoplight package repo by copying-and-pasting the contents
below into a terminal:

```bash
# expose credentials to environment first
REPO_USERNAME="myusername"
REPO_PASSWORD="mypassword"

# write credentials to repo file
cat <<EOF | sudo tee /etc/yum.repos.d/stoplight.repo
[stoplight]
name=Stoplight Package Repository
baseurl=https://$REPO_USERNAME:$REPO_PASSWORD@pkg.stoplight.io/rpm
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://pkg.stoplight.io/stoplight.key
EOF
```

> Make sure that the repository credentials are set before issuing the `cat` command above.

#### Installing the Package

Once the repository is configured properly, you can install the package using
the command:

```bash
sudo yum install stoplight-frontend -y
```

To start the service, run the command:

```bash
sudo systemctl start stoplight-frontend
```

Once started, you can see the status of the service using the command:

```bash
sudo systemctl status stoplight-frontend
```

## Configuration Options

The configuration file for this component defaults to:

```bash
/etc/stoplight-frontend/stoplight-frontend.cfg
```

Be sure to customize any variables as needed to match your environment
**before** starting the service. Any changes to the configuration will require a
service restart in order to take effect.

```bash
sudo systemctl restart stoplight-frontend
```

#### SL_API_URL

Full URL to the backend API.

```
SL_API_URL=http://stoplight-api.example.com:4060
```
