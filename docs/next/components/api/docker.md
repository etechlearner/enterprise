---
layout: page
parent: API
grand_parent: Stoplight Next
title: Docker Installation
nav_order: 2
toc: true
permalink: next/api/docker
---

# Docker

## Pulling the Image

To install the API component with Docker, run the command below:

```bash
docker pull quay.io/stoplight/api
```

> Note, if the system you are using has not already authenticated with the
> Stoplight container registry, you will be prompted for credentials.

## Starting the Service

To start the API container, run the command:

```bash
docker run \
	--restart on-failure \
	-p 3030:3030 \
	quay.io/stoplight/api:latest
```

> Remember to set any necessary environment variables

If started properly, the container should be marked with a healthy status after
30 seconds. Use the `docker ps` command to verify the container was started and
is running properly.
