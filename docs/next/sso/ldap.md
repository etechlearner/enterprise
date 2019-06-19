---
layout: page
parent: SSO
title: LDAP Integration
nav_order: 3
nav_no_fold: true
permalink: next/sso/ldap
grand_parent: Stoplight Next
---

{% raw %}

# Enabling LDAP SSO in Stoplight

To enable LDAP in Stoplight, _both_ the **API** and **app** component
configurations must be updated. Review the instructions below for each
component.

> Please note, Stoplight's LDAP integration does not currently use directory
> data for determining group/organization membership. Group/organization
> membership should be managed through the Stoplight application itself.

## App

For the Stoplight app component, set the following variable in the process
environment:

```bash
SL_LOGIN_PATH='/sso/global/ldap/login'
```

If you are running in a container-based environment, the variable can be set in
the container environment directly.

If you are running from RPM package, you can add the variable to the app
package configuration located at:

```bash
/etc/stoplight-app/stoplight-app.cfg
```

Once set, be sure to restart the process.

## API

For the Stoplight API component, set the following variable in the process
environment:

```bash
SL_SSO_LDAP_CONFIG='{"server":{"url":"ldap://localhost:389","bindDN":"cn=admin,dc=example,dc=org","bindCredentials":"machu_pichu","searchBase":"dc=example,dc=org","searchFilter":"(uid={{username}})"}}'
```

> Note, you may need to escape the double-quotes in the JSON body above
> depending on your run time environment.

Where the content of the `SL_SSO_LDAP_CONFIG` environment variable is a JSON
object in minified string format. When displayed in an expanded format:

```json
{
  "server": {
    "url": "ldap://localhost:389",
    "bindDN": "cn=admin,dc=example,dc=org",
    "bindCredentials": "super_secret_password",
    "searchBase": "dc=example,dc=org",
    "searchFilter": "(uid={{username}})"
  }
}
```

Under the `server` key, the following options are available:

- `url`: e.g. `ldap://localhost:389` or `ldaps://localhost:689`

- `bindDN`: e.g. `cn='root'`

- `bindCredentials`: Password for `bindDN` parameter above

- `searchBase`: e.g. `o=users,o=example.com`

- `searchFilter`: LDAP search filter, e.g. `(uid={{username}})`. Use literal
  `{{username}}` to have the given username used in the search.

- `searchAttributes`: Optional array of attributes to fetch from LDAP server,
  e.g. `['displayName', 'mail']`. Defaults to `undefined`, i.e. fetch all
  attributes

If you are running from RPM package, you can add the variable to the API
package configuration located at:

```bash
/etc/stoplight-api/stoplight-api.cfg
```

Once set, be sure to restart the process.

## Common Issues

### Receiving "Invalid LDAP configuration" when authenticating

This error is referring specifically to the JSON syntax of the
`SL_SSO_LDAP_CONFIG` variable in the Stoplight API component.

To resolve, double check the JSON _syntax_ (and whitespace, escaping, etc) in the
variable itself and restart the process.
{% endraw %}
