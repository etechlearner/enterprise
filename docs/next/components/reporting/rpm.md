---
layout: page
parent: Reporting
title: RPM Installation
grand_parent: Stoplight Next
nav_order: 3
toc: true
permalink: next/reporting/rpm
---

# RPM Installation

Prior to installing the Reporting RPM package, you will need to:

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

## Installing the Reporting Package

Once the repository is configured properly, you can install the Reporting
component using the command:

```bash
sudo yum install stoplight-reporting -y
```

## Running

To start the reporting process, simply run the command:

```bash
sudo stoplight-reporting
```

This component is run in an ad-hoc fashion, so there is no service requirement
(though it can be run on a cron if needed).

## Output

By default, output will be written to the directory from where the process was
started.

```bash
$ stoplight-reporting
---> Starting Stoplight Reporting Tool v0.1.3 @ 1561499962...
---> Found 32 projects...
```

Once the process is completed, there will be two CSV-formatted files available
for review in the current directory:

```bash
$ ls -l
total 2177
-rw-rw-r--. 1 my-user my-user      333 Jun 25 21:46 validations.1561499962.csv
-rw-rw-r--. 1 my-user my-user      333 Jun 25 21:59 overview.1561499962.csv
```

The output files are:

- `overview.$TIMESTAMP.csv` is the summary data collected across all projects.

- `validations.$TIMESTAMP.csv` is the validation data collected against every
  specification.
