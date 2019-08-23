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

## Running Locally

To start the Stoplight process using `docker run`:

```bash
# create local data directory
mkdir stoplight-data
chmod -R 777 stoplight-data

# start the service
docker run --name stoplight-platform \
    -p 8080:8080 \
    -v $(pwd)/stoplight-data:/home/node/postgresql \
    quay.io/stoplight/platform
```

Note:

- The `-v $(pwd)` means the Platform data directory will be stored in the __current local directory__ from where the `docker run` command is being run. You can replace `$(pwd)` with a full path (ie, `/data/stoplight`) if you would like to store data somewhere else on the host system.

- All data used by Stoplight is stored within the PostgreSQL data directory located at `/home/node/postgresql`, so be sure to include the `-v` option referenced above to ensure data is persisted outside the container.

- The master process inside the container runs as the container's `nginx` user, which has a UID of `101`. Make sure that this user has write permissions to the mounted volume (specified with `-v`). This is handled by the `chmod` command at the start of the snippet above.

## Running Remotely

To start the Stoplight process when running remotely, you will need to follow the instructions [above](#running-locally) as well as set the following variable:

- `SL_API_URL`, which is the fully-qualified URL of the Stoplight instance with an `/api` suffix (ie, `http://stoplight.myorg.com:1234/api`)

To start the Stoplight process using `docker run`:

```bash
# create local data directory
mkdir stoplight-data
chmod -R 777 stoplight-data

# start the service
docker run -d --name stoplight-platform \
    -p 8080:8080 \                                      # * if this is updated, update SL_API_URL
    -v $(pwd)/stoplight-data:/home/node/postgresql \
    -e SL_API_URL=http://stoplight.myorg.com:8080/api \ # * update to your hostname/IP _and_ port
    quay.io/stoplight/platform
```

### Enabling SSL

To enable SSL, you will need to include the environment variables:

- `SL_ENABLE_SSL=true`, which enables the SSL logic in the container runtime.

- `SL_HOSTNAME=certhostname.example.com`, where the value is the fully-qualified hostname of the running container (ie, the hostname that the certificate was created for).

- `SL_API_URL=https://certhostname.example.com/api`, where the value is the fully-qualified hostname of the running Stoplight Platform container. This is typically `https://` + `$SL_HOSTNAME` (above) + `/api`.

This makes the final `docker run` command:

```bash
docker run -d --name stoplight-platform \
    -v $(pwd)/stoplight-data:/home/node/postgresql \
    -p 8443:8443 \                                                          # * ssl binds to 8443
    -e SL_ENABLE_SSL=true \                                                 # *
    -e SL_HOSTNAME=certhostname.example.com \                               # * update this to your hostname
    -e SL_API_URL=https://certhostname.example.com/api \                    # * include https in URL
    -v ./path/to/cert.pem:/etc/nginx/custom-certificates/fullchain.pem \    # *
    -v ./path/to/key.pem:/etc/nginx/custom-certificates/privkey.pem \       # *
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

### Disabling IPv6

If you would like to prevent nginx from binding to IPv6 interfaces, set the `DISABLE_IPV6` environment variable to the value `true`:

```bash
-e DISABLE_IPV6=true
```

### Accessing Supervisor

If you ever need to access the running [supervisord](http://supervisord.org/) process in order to control running processes within the container, you can do so by running the command:

```bash
docker exec -it stoplight-platform supervisorctl
```

By accessing supervisord, you can see the process status, restart services, and more:

```bash
$ docker exec -it stoplight-platform supervisorctl
backend                          RUNNING   pid 1470, uptime 1:31:47
frontend                         RUNNING   pid 1468, uptime 1:31:47
nginx                            RUNNING   pid 1467, uptime 1:31:47
postgres                         RUNNING   pid 1469, uptime 1:31:47
supervisor> restart nginx
nginx: stopped
nginx: started
supervisor>
```

To disable the `supervisorctl` access, set the `SUPERVISOR_RPC_DISABLED` environment variable to `true`:

```bash
-e SUPERVISOR_RPC_DISABLED=true
```

### Taking a Backup

To take a backup of the running Stoplight container, use the included `pg_dump` utility to export the PostgreSQL database:

```bash
docker exec -it stoplight-platform pg_dump stoplight > stoplight-backup.$(date +%Y.%m.%d_%H%M%S).sql
```

Once the command above completes, you will have a `stoplight-backup.*.sql` file with a timestamp of when the backup was taken that can then be loaded into a new system.

### Restoring from Backup

> **NOTE**, be sure to erase any pre-existing application data before restoring a database backup.

To restore from a backup, you will use the included `pg` utility to import data from a pre-existing SQL backup file:

```bash
# copy backup into running container, under /tmp/
docker cp stoplight-backup.sql platform:/tmp/

# stop the backend service (if not already)
docker exec -it platform supervisorctl stop backend

# restore the backup
docker exec -it stoplight-platform pg -f /tmp/stoplight-backup.sql stoplight

# start the backend
docker exec -it platform supervisorctl start backend
```

Once completed, be sure to use the same `SL_APP_SECRET` from the previous installation to prevent user sessions and secrets from being invalidated.
