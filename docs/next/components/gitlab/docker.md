---
layout: page
parent: GitLab
grand_parent: Stoplight Next
title: Docker Installation
nav_order: 2
toc: true
permalink: next/gitlab/docker
---

# Docker

## Pulling the Image

To install the GitLab component with Docker, run the command below:

```bash
docker pull quay.io/stoplight/gitlab:v11.0.6
```

> Note, if you have not already authenticated with the Stoplight container
> registry, you will be prompted for credentials

## Starting the Service

To start the GitLab container, run the command:

```bash
docker run \
        --restart on-failure \
		-v /my/config:/etc/gitlab \
		-p 8080:8080 \
		quay.io/stoplight/gitlab:v11.0.6
```

If started properly, the container should be marked with a healthy status after
60 seconds. Use the `docker ps` command to verify the container was started and
is running properly.

> Note when booting for the first time, it is not unusual for GitLab to take
> longer than 3-4 minutes.
