---
layout: page
parent: GitLab
grand_parent: Stoplight Next
title: Configuration
nav_order: 4
toc: true
permalink: next/gitlab/configuration
---

# Configuration

The below sample configuration can be used as a starting point for the GitLab
configuration:

```rb
# ! Replace this with the full URL to where Stoplight is being hosted. Be sure to
# set to the URL of the Stoplight application front-end, _not_ the
# URL for GitLab
external_url 'http://localhost:3100'

# initial root user password, only valid on first boot
gitlab_rails['initial_root_password'] = "password"

# nginx configuration
nginx['enable'] = true
nginx['listen_port'] = 8000
nginx['listen_addresses'] = ['0.0.0.0']
nginx['listen_https'] = false
nginx['proxy_set_headers'] = {
  "X-Forwarded-Proto" => "http",
  "X-Forwarded-Ssl" => "off"
}

# redis configuration
redis['enable'] = true
redis['bind'] = '0.0.0.0'
redis['port'] = 6379

# postgresql configuration
# if not using the embedded database, set postgresql['enable'] to false
postgresql['enable'] = true
postgresql['listen_address'] = '0.0.0.0'
postgresql['port'] = 5432

# if not using the embedded postgres, uncomment the lines below
# gitlab_rails['db_username'] = "gitlab"
# gitlab_rails['db_password'] = nil
# gitlab_rails['db_host'] = nil
# gitlab_rails['db_port'] = 5432

# !! remove this in a production environment
postgresql['custom_pg_hba_entries'] = {
    gitlab: [
        {
        type: 'host',
        database: 'all',
        user: 'all',
        cidr: '0.0.0.0/0',
        method: 'trust'
        }
    ]
}
```

> **NOTE**, the `postgresql['custom_pg_hba_entries']` variable disables
> authentication/authorization for the database when the embedded PostgreSQL
> database is active. Be sure to remove this entry once the database has been
> configured with the proper user permissions.

After any configuration changes are made, run:

```shell
sudo gitlab-ctl reconfigure
```

In order for the configuration changes to be persisted to the runtime.

## Location

### RPM

The GitLab configuration file is located at:

```bash
/etc/gitlab/gitlab.rb
```

The above file encompasses all of the different configuration options exposed by
GitLab. This guide only covers those specific to Stoplight.

> For documentation on other GitLab configuration options, see the official
> documentation [here](https://docs.gitlab.com/omnibus/README.html#configuring)

### Docker

The GitLab container should be configured nearly identically to the package
installation described above. The easiest way to do this is to mount the GitLab
configuration directory inside the container.

To mount the configuration inside the container, use the `-v` argument to the
`docker run` command:

```bash
docker run -v /data/gitlab-config:/etc/gitlab ...
```

Where `/data/gitlab-config` is a directory containing your `gitlab.rb`
configuration file.

> See [here](https://docs.gitlab.com/omnibus/README.html#configuring) for more
> information on how to configure GitLab.

## Variables

### external_url

`external_url` is the canonical URL for the Gitlab instance (scheme, hostname,
and port included).

```ruby
external_url 'http://stoplight.example.com:8080'
```

> If you are configuring GitLab to send emails, set the `external_url` to the
> URL of the **Stoplight App** component, and not GitLab itself.

### ssl

To enable SSL, update the `external_url` setting with a `https://` prefix, which
will enable SSL connections over port 443. Once updated, set the certificate and
private key locations using the following configuration:

```ruby
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.example.com.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.example.com.key"
```

If you would like to _only_ serve requests over HTTPS, use the following
configuration:

```ruby
nginx['redirect_http_to_https'] = true
```

### postgresql

To configure GitLab to use an external database (ie, the database _not_ embedded
within the GitLab package), use the following configuration:

```ruby
postgresql['enable'] = false
gitlab_rails['db_database'] = "stoplight"
gitlab_rails['db_username'] = "dbuser"
gitlab_rails['db_password'] = "dbpassword"
gitlab_rails['db_host'] = "postgres.example.com"
gitlab_rails['db_port'] = 5432
gitlab_rails['db_sslmode'] = "allow"
```

### redis

To configure GitLab to use an external redis (ie, the redis instance _not_
embedded within the GitLab package), use the following configuration:

```ruby
redis['enable'] = false
gitlab_rails['redis_host'] = "HOST"
gitlab_rails['redis_port'] = PORT
gitlab_rails['redis_database'] = "stoplight"
redis['maxclients'] = "10"
```

### email

To configure email, update the GitLab configuration with the following entries:

```ruby
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'email-from@example.com'
gitlab_rails['gitlab_email_display_name'] = 'Stoplight'
gitlab_rails['gitlab_email_reply_to'] = 'email-reply@example.com'
```

> If you would like for your Stoplight instance to send emails, be sure to
> update the SMTP settings below in addition to the email settings.

### smtp

To configure SMTP to enable email notifications, update the GitLab configuration
with the following entries:

```ruby
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.example.com"
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_domain'] = "smtp.example.com"
```

If the SMTP server requires authentication:

```ruby
gitlab_rails['smtp_user_name'] = "USER"
gitlab_rails['smtp_password'] = "PASSWORD"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
```

If the SMTP server requires TLS:

```ruby
gitlab_rails['smtp_tls'] = true
```

## FAQs

### Can I use the embedded Redis or PostgreSQL for other services?

Yes! To expose the embedded Redis instance to the outside world, use the configuration:

```ruby
redis['bind'] = '127.0.0.1'
redis['port'] = 6379
```

> If you need Redis to accept external requests, then update the `bind` variable above to equal `0.0.0.0`.

Similarly, for PostgreSQL, use the configuration:

```ruby
postgresql['listen_address'] = '127.0.0.1'
postgresql['port'] = 5432
```

> If you need PostgreSQL to accept external requests, then update the `listen_address` variable above to equal `0.0.0.0`.

Once the configuration changes are made, issue a `gitlab-ctl reconfigure` for the changes to take effect.

> If running GitLab in Docker, be sure to expose the Redis/PostgreSQL ports with the `-p` command-line option

For more information on configuring Redis, see the official GitLab documentation
[here](https://docs.gitlab.com/omnibus/settings/redis.html).

### Can I specify GitLab users as administrators?

Yes, GitLab administrators can be selected by editing the user you would like to
assign as an admin. Administrative rights can be set under the "Access" section
of the user modification screen in GitLab.

> Please note, GitLab administrators have administrative rights in Stoplight as
> well. Administrators can see and edit all projects hosted within Stoplight.

### Can I allow users created in GitLab to have access to Stoplight?

Yes, in order for a GitLab-created user to have access to the Stoplight
platform, an impersonation token must be created for their account. The
impersonation token management screen can be found in the user administration
screen, under the "Impersonation Tokens" tab.

To create a Stoplight access token, make sure:

- The name of the token is equal to `stoplight`
- The token must have `api` scope

### Can I install the GitLab RPM in a Docker container?

Yes, if you are unable to use the official Stoplight Docker image, but would
still like to use the RPM, you will need to:

- Install the RPM into the container following the RPM installation instructions
  above.

- Copy
  [this](https://github.com/stoplightio/gitlabhq/blob/stoplight/develop/scripts/docker-entrypoint.sh)
  script into the Docker image at any location, and make executable (`chmod +x /path/to/script`).

- For the Docker
  [entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint) or
  [cmd](https://docs.docker.com/engine/reference/builder/#cmd) instruction, use
  the script from the previous step.

And that's it!
