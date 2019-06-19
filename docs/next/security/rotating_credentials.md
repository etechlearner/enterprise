---
layout: page
parent: Security
title: Rotating Security Credentials
nav_order: 3
permalink: next/security/rotating_credentials
grand_parent: Stoplight Next
---

# Rotating Credentials

Rotating credentials for the Stoplight platform is a simple and quick method for
ensuring the integrity and security of your Stoplight installation. Credential
rotation is recommended for all production deployments on a regular interval.

In each section below, we'll use the following terms:

- The term "credentials" can refer to both a username/password pair or an
  application secret depending on the context.

- The phrase "old credentials" refers to the credentials being rotated _from_.
  These are the credentials that are currently in use.

- The phrase "new credentials" refers to the credentials being rotated _to_.
  These are the credentials that are not yet in use.

## Rotating PostgreSQL Credentials

PostgreSQL serves as the relational datastore for the Stoplight platform, and is relied on by the following Stoplight components:

- GitLab
- API

When PostgreSQL credentials are rotated, be sure to restart and verify each
service above.

To rotate credentials for one or more PostgreSQL accounts, follow the steps
below for **each** account:

- Before removing old credentials, create an _entirely new_ set of
  credentials for the user being rotated.

  ```sql
  create user new_user with encrypted password 'new_password';
  grant all privileges on database stoplight_database to new_user;
  ```

  > **Note**, that this step includes creating a new username as well as a new
  > password for the new credentials.

- Set the new credentials in the dependendant services, and restart the services. Verify that the new credentials are now being used by all connected services.

- Remove the old credentials.

  ```sql
  drop user old_user;
  ```

## Rotating Redis Credentials

Redis serves as the key-value store for the Stoplight platform, and is relied on by the following Stoplight components:

- GitLab
- API
- Tasker

To rotate credentials for one or more Redis accounts, follow the steps below for
**each** account:

- Before removing old credentials, create an _entirely new_ set of credentials
  for the user being rotated. The exact commands for this vary depending on the
  variant of Redis you are using, so please check the documentation for your
  local Redis installation.

  > If you are using vanilla Redis, then only one set of credentials can be set
  > at one time. If this is the case, you will want to update the set password
  > at the same time as you restart the dependant services.

- Set the new credentials in the dependendant services, and restart the services. Verify that the new credentials are now being used by all connected services.

- If applicable, remove the old credentials.

## Rotating GitLab Credentials

GitLab serves as the backing document store for the Stoplight platform, and is relied on by the following Stoplight components:

- API, which the following services rely on for API keys:
  - Pubs
  - Prism

> **Note**, the Stoplight API retrieves its own token directly from the database
> on startup, and so does not need to be rotated directly. The database
> credentials used by the API should be rotated instead.

There are two sets of credentials stored within GitLab:

1. The administrative password for the default GitLab administrator (typically
   the `root` user). This can be set manually on first startup of the GitLab
   process, or is embedded within the GitLab configuration.

   Once set, the GitLab administrator password can be managed from the following
   URL:

   `https://stoplight-gitlab.your-company.com/profile/password/edit`

   > _Note_, you must be signed in as the `root` user in order to update the
   > account password.

   The administrative password is only used for accessing the GitLab
   administrators web UI, and is not used by any dependent services.

2. The API keys that are used by dependant services. These are created and
   managed by GitLab itself, and can be managed within the GitLab user interface
   by any user with administrative privileges.

   To rotate an API key credential in use by a dependant service (Pubs or
   Prism), you'll want to:

   - Navigate to the following URL when logged in as an administrative user:

     `https://stoplight-gitlab.your-company.com/profile/personal_access_tokens`

     This interface provides methods for viewing, creating, or revoking active API keys.

   - Before revoking the old credentials, create a new credential (API token)
     for the dependent service. Once created, set the API key in the service
     configuration, restart the service, and verify it is healthy before
     proceeding.

   - Revoke the old credentials previously in use by the service.

## Rotating API Signing Keys

The Stoplight API acts as the entrypoint for all client communication into the Stoplight platform. Within the API configuration there are three signing keys used:

- `SIGN_SECRET` - This key is used for signing authenticated user sessions.
- `AUTH_SECRET` - This key is used for server-side oauth2 handshakes.
- `SL_JWT_SECRET` - This key is used for encrypting client JWT tokens that wrap the user sessions.

Each of these keys can be rotated at any time, however, when rotated, **all user
sessions** will be invalidated and all users will have to re-login to the
Stoplight platform. Due to this, we recommend rotating these credentials during
off-hours to lessen the impact to current users on the platform.
