---
layout: page
parent: GitLab
grand_parent: Stoplight Next
title: RPM Installation
nav_order: 3
permalink: next/gitlab/rpm
---

# RPM Installation

Prior to installing the RPM package, you will need to have the Stoplight package
repository installed and configured with your user-specific credentials.

You can do this by copying-and-pasting the contents below into a terminal:

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

Once the repository is configured properly, you can install the GitLab component
using the command:

```bash
sudo yum install stoplight-gitlab -y
```

> Once installed, head over to the [GitLab configuration
> page](/next/gitlab/configuration) to configure the service before starting it.

## Running

To start the GitLab server, run the command:

```bash
sudo gitlab-ctl start
```

Once started, you can see the status of the service using the command:

```bash
sudo gitlab-ctl status
```
