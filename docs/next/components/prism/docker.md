---
layout: page
parent: Prism
grand_parent: Stoplight Next
title: Docker Installation
nav_order: 2
toc: true
permalink: next/prism/docker
---

# Docker

## Pulling the Image

To install the Prism component with Docker, run the command below:

```bash
docker pull quay.io/stoplight/prism-multi
```

> Note, if the system you are using has not already authenticated with the
> Stoplight container registry, you will be prompted for credentials.

## Starting the Service

To start the Prism container, run the command:

```bash
docker run \
	--restart on-failure \
	-p 4050:4050 \
	quay.io/stoplight/prism-multi:latest
```

> Remember to set any necessary environment variables

If started properly, the container should be marked with a healthy status after
30 seconds. Use the `docker ps` command to verify the container was started and
is running properly.
