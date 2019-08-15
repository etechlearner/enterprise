---
layout: default
title: Docker Quick Start
nav_order: 2
has_children: false
parent: API Design Manager
permalink: design-manager/docker-quick-start
---

# Docker Quick Start

The Stoplight Platform comes as a single container image, making it simple to both run and manage at any scale.
Apart from the Stoplight application code itself, also included in the container is:

- The latest [PostgreSQL Server v10](https://www.postgresql.org/docs/10/index.html) release

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

To verify the image is accessible, run:

```bash
docker pull quay.io/stoplight/platform
```

## Running

To start the Stoplight Platform process you will need the following variables:

- `SL_API_URL`, which is the fully-qualified URL of the Stoplight instance with a `/api` suffix

To start the Stoplight process using `docker run`:

```bash
docker run -d --name stoplight-platform \
    -p 8080:8080 \
    -v $(pwd)/stoplight-data:/home/node/postgresql \
    -e SL_API_URL=http://stoplight.example.com/api \
    quay.io/stoplight/platform
```

Note:

- All data used by Stoplight is stored within the PostgreSQL data directory located at `/home/node/postgresql`, so be sure to include the `-v` option referenced above to ensure data is persisted outside the container.

- The master process inside the container runs as the container's `nginx` user, which has a UID of `101`. Make sure that this user has write permissions to the mounted volume (specified with `-v`).

### Enabling SSL

To enable SSL, you will need to include the environment variables:

- `SL_ENABLE_SSL=true`, which enables the SSL logic in the container runtime.

- `SL_HOSTNAME=certhostname.example.com`, where the value is the fully-qualified hostname of the running container (ie, the hostname that the certificate was created for).

- `SL_API_URL=https://certhostname.example.com/api`, where the value is the fully-qualified hostname of the running Stoplight Platform container. This is typically `https://` + `$SL_HOSTNAME` (above) + `/api`.

This makes the final `docker run` command:

```bash
docker run -d --name stoplight-platform \
    -v $(pwd)/stoplight-data:/home/node/postgresql \
    -p 8443:8443 \                                                      # * required for SSL
    -e SL_ENABLE_SSL=true \                                             # *
    -e SL_HOSTNAME=certhostname.example.com \                           # * update this to your hostname
    -e SL_API_URL=https://certhostname.example.com/api \
    -v ./path/to/cert:/etc/nginx/custom-certificates/fullchain.pem \    # *
    -v ./path/to/key:/etc/nginx/custom-certificates/privkey.pem \       # *
    quay.io/stoplight/platform
```

#### Self-Signed Certificates

When enabling SSL with a self-signed (or custom CA-signed) certificate,
make sure and set the environment variable
[`NODE_EXTRA_CA_CERTS`](https://nodejs.org/api/cli.html#cli_node_extra_ca_certs_file)
with the file path to the certificate.

## FAQ

### Using a Custom PostgreSQL Database

While the Stoplight container does include a version of PostgreSQL Server,
setting the `SL_POSTGRES_URL` variable to an external PostgreSQL URL will
disable the included PostgreSQL Server and, instead, use the external PostgreSQL instance for storage.

```bash
-e SL_POSTGRES_URL=postgres://username:password@postgres.example.com:5432/stoplight
```

> When using an external PostgreSQL server, you do not need to use an external volume (`-v`) for storing application data.

### Log Output

Log output for the Stoplight processes are available at the paths below:

- `/home/node/log/frontend.log`
- `/home/node/log/backend.log`
- `/home/node/log/nginx.log`
- `/home/node/log/postgres.log`

If you would like the container to send output to stdout instead of a log file, set the `EMIT_STDOUT` environment variable to the value `true`:

```bash
-e EMIT_STDOUT=true
```
