---
layout: page
parent: API
title: Networking Requirements
grand_parent: Stoplight Next
nav_order: 1
toc: true
permalink: next/api/networking
---

# Networking

## Default Port Settings

The default port for the API component is TCP port **3030**. The port can be
customized using the `PORT` configuration variable.

## Incoming Traffic

The API must be able to receive incoming connections from the following components:

- User Clients (web browser or desktop application)
- App

## Outgoing Traffic

The API must be able to make outgoing connections to the following components:

- PostgreSQL
- Redis
- Gitlab
- Prism

## Websockets

In addition, the API makes use of
[websocket](https://en.wikipedia.org/wiki/WebSocket) connections for real-time
notifications and updates to application users. In particular, websockets are
used for:

- Displaying editor notifications when multiple users are editing the same file
- Displaying build logs while a Hub or spec is being built
- Displaying notifications for when a Hub or spec build is completed

If websockets are not supported within your environment, clients will revert
to HTTP polling.
