---
layout: page
parent: Prism
title: RPM Installation
grand_parent: Stoplight Next
nav_order: 3
toc: true
permalink: next/prism/rpm
---

# RPM Installation

Prior to installing the RPM package, you will need to:

- Have the Stoplight package repository installed and configured with your
  user-specific credentials

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
sudo yum install prism -y
```

## Running

To start the API server, run the command:

```bash
sudo systemctl enable prism
sudo systemctl start prism
```

Once started, you can see the status of the service using the command:

```bash
sudo systemctl status prism
```
