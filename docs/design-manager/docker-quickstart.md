---
layout: default
title: Docker Quick Start
nav_order: 2
has_children: false
parent: API Design Manager (beta)
permalink: design-manager/docker-quick-start
---

# Docker Quick Start

The Stoplight Platform comes as a single container image, making it simple to both run and manage at any scale.
Apart from the Stoplight application code itself, also included in the container is:

- The latest [PostgreSQL v10](https://www.postgresql.org/docs/10/index.html) release

- The latest release of [NodeJS v10.16 LTS](https://nodejs.org/en/about/releases/)

- The latest release of [nginx](https://nginx.org/en/)

- The latest release of [Supervisor](http://supervisord.org/)

All of the components above are included (but not always used) to ensure the running container has everything it needs to run with as few dependencies as possible.

## System Requirements

- Docker, or another compatible container runtime (Kubernetes, OpenShift, etc) with access to at least **2 CPUs** and **4GB of memory**

- Network access to the running container port, which defaults to **8080** (but can be remapped). If SSL will be enabled, the default port is **8443**.

### SSL Requirements

If SSL will be enabled, you will also need:

- SSL certificate in the PEM format 

- SSL secret key in the PEM format

## Authenticating with the Container Registry

Before you can run the Stoplight Platform container, you will need to login to the Stoplight container registry:

```bash
docker login -u="username" -p="password" quay.io
```

> The credentials used above will be provided by the Stoplight Customer Success team at the beginning of your evaluation or implementation. Please [contact us](mailto:customers@stoplight.io) if you do not have registry credentials.

## Running

To start the Stoplight Platform process locally with Docker, run:

```bash
docker run -d --name stoplight-platform \
    -p 8080 \
    -e SL_API_URL=https://stoplight.example.com/api \
    quay.io/stoplight/platform
```

### Enabling SSL

To enable SSL, you will need to include the environment variables:

- `SL_ENABLE_SSL=true`, which enables the SSL logic in the container runtime

- `SL_HOSTNAME=certhostname.example.com`, where the value is the fully-qualified hostname of the running container (ie, the hostname that the certificate was created for)

- `SL_API_URL=https://certhostname.example.com/api`, where the value is the fully-qualified hostname of the running Stoplight Platform container. This is typically `https://` + `$SL_HOSTNAME` (above) + `/api`.

This makes the final `docker run` command:

```bash
docker run -d --name stoplight-platform \
    -p 8443 \
    -e SL_ENABLE_SSL=true \
    -e SL_HOSTNAME=certhostname.example.com \
    -e SL_API_URL=https://certhostname.example.com/api \
    -v ./path/to/cert:/etc/nginx/custom-certificates/fullchain.pem \
    -v ./path/to/key:/etc/nginx/custom-certificates/privkey.pem \
    quay.io/stoplight/platform
```

#### Self-Signed Certificates

When enabling SSL with a self-signed (or custom CA-signed) certificate, make sure and set the environment variable [`NODE_EXTRA_CA_CERTS`](https://nodejs.org/api/cli.html#cli_node_extra_ca_certs_file) with the file path to the certificate.
