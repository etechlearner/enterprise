---
layout: page
parent: App
grand_parent: Stoplight Next
title: Configuration
nav_order: 4
toc: true
permalink: next/app/configuration
---

# Configuration

To configure the Stoplight app component, you will need to provide runtime
values and connection details to the other necessary Stoplight components. The
app can be configured either by the configuration file or through the
environment.

> The same configuration variables can be used regardless of installation type
> (container or package-based).

## Location

### Docker

To expose configuration variables to the Docker runtime, either write them to a
file and use the `--env-file` argument:

```bash
cat <<EOF>app-env-vars
SL_API_HOST="..."
...
EOF

docker run --env-file app-env-vars ...
```

Or you can expose them one at a time with the `-e` flag:

```bash
docker run -e SL_API_HOST=https://api.stoplight.example.com ...
```

### RPM

When installed via RPM, the configuration file is located at the path:

```bash
/etc/stoplight-app/stoplight-app.cfg
```

Be sure to customize any variables as needed to match your environment
**before** starting the service.

If already running, restart the service with:

```bash
sudo systemctl restart stoplight-app
```

> Any changes to the configuration requires a service restart in order to take
> effect.

## Variables

### SL_APP_HOST

The `SL_APP_HOST` is the public-facing URL for the Stoplight application.

```
SL_APP_HOST="https://stoplight.example.com"
```

### SL_API_HOST

The `SL_API_HOST` is the URL to the Stoplight API.

```
SL_API_HOST="https://stoplight-api.internal.example.com:3030"
```

### SL_EXPORTER_HOST

<blockquote style="background-color: #ffa8c0; color: black !important;">
<b>NOTE</b> This variable was deprecated with the v4.8 release of Stoplight Next.
</blockquote>

The `SL_EXPORTER_HOST` is the full URL to the Stoplight Exporter instance:

```
SL_EXPORTER_HOST="https://stoplight-exporter.internal.example.com"
```

### SL_PRISM_HOST

The `SL_PRISM_HOST` is the full URL to the Stoplight Prism instance

```
SL_PRISM_HOST="https://stoplight-prism.internal.example.com"
```

### SL_PUBS_HOST

The `SL_PUBS_HOST` variable is the top-level domain used for documentation:

```
SL_PUBS_HOST="docs.example.com"
```

### SL_PUBS_INGRESS

The `SL_PUBS_INGRESS` variable is the URL to the Stoplight Pubs instance admin API:

```
SL_PUBS_INGRESS="https://pubs.example.com:9098"
```
