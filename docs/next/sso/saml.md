---
layout: page
parent: SSO
title: SAML Integration
nav_order: 4
nav_no_fold: true
---

# Configuring SAML Authentication

To configure Stoplight to use SAML authentication, follow the instructions
below.

> Please note, Stoplight's SAML integration does not currently use
> SAML assertions for determining group/organization
> membership. Group/organization membership should be managed through
> the Stoplight application itself.

## API

To configure Stoplight to use SAML for user authentication, add the following
variable to the Stoplight API configuration/environment:

```bash
SL_SSO_ENTRYPOINT="https://your-saml-server.example.com/..."
```

Where `SL_SSO_ENTRYPOINT` is the full URL to the SAML server providing
the SAML assertions.

Once set in the API configuration, restart the API:

```bash
# docker installs
sudo docker restart stoplight-api

# package installs
sudo systemctl restart stoplight-api
```

## App

To configure Stoplight to use SAML for user authentication, add the following
variable to the Stoplight App configuration/environment:

```bash
SL_SSO_ENTRYPOINT="https://stoplight-api.example.com:3030/sso/global/saml/login"
```

Where `https://stoplight-api.example.com:3030` is the scheme, hostname, and port
corresponding to your Stoplight API server.

Once set in the app configuration, restart the app:

```bash
# docker installs
sudo docker restart stoplight-api

# package installs
sudo systemctl restart stoplight-api
```

Once restarted, all login requests will be authenticated via the
external SAML service.

## SAML IdP Metadata

To configure Stoplight SAML integration from the SAML server, use the following SAML metadata file:

```xml
<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" entityID="stoplight" ID="stoplight">
<SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
<NameIDFormat>
urn:oasis:names:tc:SAML:2.0:nameid-format:persistent
</NameIDFormat>
<AssertionConsumerService index="1" isDefault="true" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://stoplight-api.internal.example.com/sso/global/saml/callback"/>
</SPSSODescriptor>
</EntityDescriptor>
```

Be sure to update the `AssertionConsumerService` / `Location` object
with the correct callback URL for the Stoplight API.

## SAML Group Mappings

> This functionality is available starting with the **v4.9.0** release of the
> Stoplight API.

While the Stoplight platform does not currently use any SAML user metadata for
determining group membership automatically, the `SL_SSO_SAML_GROUP_MAPPING`
environment variable is one way to manually set this group membership at the
configuration level.

Here is a sample configuration value:

```bash
SL_SSO_SAML_GROUP_MAPPING='[{ "samlAttributeName": "top-secret", "whenEqualTo": "true", "groupMappings": ["restricted", "top-secret"] }]'
```

Where the value of this variable is a JSON array of objects:

```json
[
  {
    "samlAttributeName": "top-secret",
    "whenEqualTo": "true",
    "groupMappings": ["restricted", "top-secret"]
  }
]
```

Each object in this array is treated as an assertion that is applied to each
user as they login to Stoplight. Using the example above, the assertion is: If
the saml assertion metadata for the current user contains the key `top-secret`
and this value is equal to the string `true`, add this user to the `restricted`
and `top-secret` Stoplight organizations (based on their namespace path).

Some important things to note about this functionality:

- The `samlAttributeName` is the key of the value within the SAML assertion data
  returned by your identity provider.

- The `groupMappings` attribute is an array of organization **paths**. An
  organization path is the URL path in which it is located. Using the example
  above, the organizations must be located at the path
  `stoplight.example.com/restricted` and `stoplight.example.com/top-secret`.

- The `whenEqualTo` attribute takes a **string** argument. SAML assertion data
  is cast to strings, so comparison is done on strings alone.

- This logic is only **additive** and is done **at login time**, meaning that
  users are not proactively removed from these organizations and users must
  login in order to be added.

If you have any questions or concerns about this functionality, please consult
Stoplight Support at customers@stoplight.io.
