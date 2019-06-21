---
layout: page
parent: Prism
title: Configuration
grand_parent: Stoplight Next
nav_order: 4
toc: true
permalink: next/prism/configuration
---

# Configuration

To configure the Prism component, you will need to provide runtime settings and
connection details to the Stoplight API.

## Location

### Docker

To expose configuration variables to the Docker runtime, either write them to a
file and use the `--env-file` argument:

```bash
cat <<EOF>prism-env-vars
SL_API_HOST="..."
...
EOF

docker run --env-file prism-env-vars ...
```

Or you can expose them one at a time with the `-e` flag:

```bash
docker run -e SL_API_HOST=https://api.stoplight.example.com ...
```

### RPM

When installed via RPM, the configuration file is located at the path:

```bash
/etc/prism/prism.cfg
```

Be sure to customize any variables as needed to match your environment
**before** starting the API service.

If already running, restart the API service with:

```bash
sudo systemctl restart prism
```

> Any changes to the API configuration requires a service restart in order to
> take effect.

## Variables

### SL_HOST

The `SL_HOST` variable is the full URL to the Prism instance.

```
SL_HOST="http://%sprism.example.com"
```

Where Prism is being served from the domain `prism.example.com`. Specifying a
port is optional.

> Note, the `%s` preceding the domain is **required**.

### SL_API_HOST

The `SL_API_HOST` variable is the full URL to the Stoplight API.

```
SL_API_HOST="http://api.example.com:3030"
```

### SL_EXPORTER_HOST

<blockquote style="background-color: #ffa8c0; color: black !important;">
<b>NOTE</b> This variable was deprecated with the v4.8 release of Stoplight Next.
</blockquote>

The `SL_EXPORTER_HOST` variable is the URL to the Stoplight Exporter.

```
SL_EXPORTER_HOST="http://exporter.example.com:3031"
```

### ENV_NAME

The `ENV_NAME` variable is a flag noting the environment level.

```
ENV_NAME="production"
```

> `ENV_NAME` should be left as `production` unless instructed otherwise by the
> Stoplight Support staff.

### MAX_QUEUE_SIZE

The `MAX_QUEUE_SIZE` variable denotes the internal queue size used to service
requests.

```
MAX_QUEUE_SIZE=500
```

> `MAX_QUEUE_SIZE` should be left as `500` unless instructed otherwise by the
> Stoplight Support staff.

### MAX_WORKERS

The `MAX_WORKERS` variable denotes the number of worker threads to use when
servicing requests.

```
MAX_WORKERS=25
```

> `MAX_WORKERS` should be left as `25` unless instructed otherwise by the
> Stoplight Support staff.

### PRISM_LOG_LEVEL

The `PRISM_LOG_LEVEL` variable denotes the log level of the Prism process.

```
PRISM_LOG_LEVEL="ERROR"
```

> `PRISM_LOG_LEVEL` should be left as `ERROR` unless instructed otherwise by the
> Stoplight Support staff.
