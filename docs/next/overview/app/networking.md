---
layout: page
parent: App
grand_parent: Stoplight Next
title: Networking Requirements
nav_order: 1
toc: true
permalink: next/app/networking
---

# Networking

## Default Port Settings

The default port for the App component is TCP port **3100**. The port can be
customized using the `PORT` configuration variable.

## Incoming Traffic

The App must be able to receive **incoming** connections from the following components:

- User Clients (web browser or desktop application)

## Outgoing Traffic

The App must be able to make **outgoing** connections to the following components:

- API
- Prism
