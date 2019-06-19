---
layout: page
parent: API
title: RPM Installation
grand_parent: Stoplight Next
nav_order: 3
toc: true
permalink: next/api/rpm
---

# RPM Installation

Prior to installing the RPM package, you will need to:

- Install NodeJS

- Have the Stoplight package repository installed and configured with your user-specific credentials

## Installing NodeJS (optional)

To install NodeJS, run the following commands:

```bash
# make sure all current versions of nodejs are removed
sudo yum remove nodejs npm -y

# install nodejs
sudo rpm -Uvh https://rpm.nodesource.com/pub_8.x/el/7/x86_64/nodejs-8.16.0-1nodesource.x86_64.rpm
```

Once the installation has completed, verify the version installed with the command:

```bash
$ node --version
v8.16.0
```

If you do not see a version starting `v8.16`, contact Stoplight support for assistance.

## Setting up the Package Repository

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

## Installing the API Package

Once the repository is configured properly, you can install the API component
using the command:

```bash
sudo yum install stoplight-api -y
```

## Running

To start the API server, run the command:

```bash
sudo systemctl enable stoplight-api
sudo systemctl start stoplight-api
```

Once started, you can see the status of the service using the command:

```bash
sudo systemctl status stoplight-api
```

## Health Check

Once the API component is running, you can verify the installation was
successful issuing an `HTTP GET` request to the `/health` endpoint:

```bash
# remember to update the scheme, host, and port here to match your installation
curl -v http://localhost:3030/health
```

If the API was installed and configured properly, you will receive an `HTTP 200`
response back.
