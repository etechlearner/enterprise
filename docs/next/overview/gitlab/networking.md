---
layout: page
parent: GitLab
grand_parent: Stoplight Next
title: Networking Requirements
nav_order: 1
toc: true
permalink: next/gitlab/networking
---

# Networking

## Default Port Settings

The default GitLab ports are 80 (HTTP) and 443 (HTTPS). These ports can be
customized via the `/etc/gitlab/gitlab.rb` configuration file.

## Incoming Traffic

GitLab must be able to receive incoming connections from the following components:

- API

## Outgoing Traffic

GitLab must be able to make outgoing connections to the following components:

- PostgreSQL
- Redis
