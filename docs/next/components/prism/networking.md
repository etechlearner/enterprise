---
layout: page
parent: Prism
title: Networking Requirements
grand_parent: Stoplight Next
nav_order: 1
toc: true
permalink: next/prism/networking
---

# Networking

## Default Port Settings

The default port for the Prism component is TCP port **4050**. The port can be
customized using the `PORT` configuration variable.

## Incoming Traffic

Prism must be able to receive incoming connections from the following components:

- User Clients (web browser or desktop application)
- API

## Outgoing Traffic

Prism must be able to make outgoing connections to the following components:

- API
- Any URL being targeted by a Scenario or proxy request

## A Note About DNS

In addition to the above requirements, Prism can be setup with a wildcard
subdomain (CNAME DNS record), for example `*.prism.example.com`, to serve mock requests. Each Prism
instance that is created gets a unique hostname associated with it, for example
`service1-mock.prism.example.com`.

If you would like to disable the use of Prism subdomains, set the [app's `SL_DISABLE_PRISM_SUBDOMAINS` configuration variable](/next/app/configuration#SL_DISABLE_PRISM_SUBDOMAINS).
