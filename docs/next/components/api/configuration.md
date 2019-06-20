---
layout: page
parent: API
title: Configuration
grand_parent: Stoplight Next
nav_order: 4
toc: true
permalink: next/api/configuration
---

# Configuration

To configure the Stoplight API component, you will need to provide runtime
values and connection details to the other necessary Stoplight components. The
API can be configured either by the configuration file or through the
environment.

> The same configuration variables can be used regardless of installation type
> (container or package-based).

## Location

### Docker

To expose configuration variables to the Docker runtime, either write them to a
file and use the `--env-file` argument:

```bash
cat <<EOF>api-env-vars
SL_APP_HOST="..."
...
EOF

docker run --env-file api-env-vars ...
```

Or you can expose them one at a time with the `-e` flag:

```bash
docker run -e SL_APP_HOST=https://stoplight.example.com ...
```

### RPM

When installed via RPM, the configuration file is located at the path:

```bash
/etc/stoplight-api/stoplight-api.cfg
```

Be sure to customize any variables as needed to match your environment
**before** starting the API service.

If already running, restart the API service with:

```bash
sudo systemctl restart stoplight-api
```

> Any changes to the API configuration requires a service restart in order to
> take effect.

## Variables

### SIGN_SECRET

The `SIGN_SECRET` variable is used to encrypt session cookies and other secrets
used by the Stoplight API.

```
SIGN_SECRET="CHANGE_ME_TO_SOMETHING_RANDOM"
```

There is no minimum or maximum character requirement, however Stoplight
recommends using a random string more than 32 characters in length for
production environments.

> Note that the `SIGN_SECRET` configuration variable must remain static between
> service restarts

### AUTH_SECRET

The `AUTH_SECRET` variable is the server-side secret used for oauth2 handshakes.

```
AUTH_SECRET="CHANGE_ME_TO_SOMETHING_RANDOM"
```

There is no minimum or maximum character requirement, however Stoplight
recommends using a random string more than 32 characters in length for
production environments.

> Note that the `AUTH_SECRET` configuration variable is required, regardless of
> whether you are using SSO or oauth, and should remain static between service
> restarts

### POSTGRES_URL

The `POSTGRES_URL` variable is the connection URI for the PostgreSQL database
shared with Gitlab.

```
POSTGRES_URL="postgres://username:password@example.com:5432/database_name"
```

### SL_COOKIE_DOMAIN

The `SL_COOKIE_DOMAIN` variable is the name of the top-level domain that
Stoplight is being served from.

```
SL_COOKIE_DOMAIN="example.com"
```

For example, if Stoplight is being served from the `stoplight.example.com`
domain, set this variable to `example.com`.

> This setting is used for
> [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
> verification. If you are unable to make requests to the API from the app, then
> this is most likely the cause.

### SL_APP_HOST

The `SL_APP_HOST` variable is the full URL to the Stoplight app component.

```
SL_APP_HOST="http://localhost:3100"
```

### SL_API_HOST

The `SL_API_HOST` variable is the full URL to this (the Stoplight API) component.

```
SL_API_HOST="http://localhost:3030"
```

### SL_EXPORTER_HOST

<blockquote style="background-color: #ffa8c0; color: black !important;">
<b>NOTE</b> This variable was deprecated with the v4.8 release of Stoplight Next.
</blockquote>

The `SL_EXPORTER_HOST` variable is the full URL to the Stoplight exporter component.

```
SL_EXPORTER_HOST="http://localhost:3031"
```

### SL_GITLAB_HOST

The `SL_GITLAB_HOST` variable is the full URL to the Stoplight GitLab instances HTTP port.

```
SL_GITLAB_HOST="http://localhost:8000"
```

### SL_REDIS_URL

The `SL_REDIS_URL` variable is the full URL to a Redis instance.

```
SL_REDIS_URL="redis://localhost:6379"
```

> If your Redis instance requires a password, insert it into the URL before the
> hostname followed with a `@` symbol. For example:
> `redis://:mypassword@localhost:6379`

### SL_PUBS_ADMIN_URL

The `SL_PUBS_ADMIN_URL` variable is the full URL to the Pubs administrative API.

```
SL_PUBS_ADMIN_URL=http://localhost:9098
```

> This setting corresponds to the Pubs `admin_bind` configuration variable.

### SL_TASKER_HOST

The `SL_TASKER_HOST` variable is the full URL to the Tasker API.

```
SL_TASKER_HOST=http://localhost:9432
```

### DISABLE_REGISTRATION

The `DISABLE_REGISTRATION` variable can be used to prevent new users from
registering with Stoplight. Enabling this feature does not prevent existing
users from inviting new users.

```
DISABLE_REGISTRATION=false
```

If this option is set to `true`, new user registration requests will receive the
following error when attempting to register:

> User registration has been temporarily disabled. Please contact your administrator.
