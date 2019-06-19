---
layout: page
parent: Overview
grand_parent: Stoplight Next
title: GitLab
nav_order: 1
has_children: true
permalink: next/gitlab
---

# GitLab

GitLab powers the Stoplight backend, including (git) file storage and relational
data.

> ## Storage Requirements
>
> GitLab requires persistent storage in order to store Stoplight file data (in
> Git), and optionally PostgreSQL data (when using the omnibus package).

Packaged within the GitLab CE is an embedded installation of PostgreSQL and
Redis. These two sub-components can be broken out into external services if
needed. You may also break out these services if you plan on using a managed
hosting solution, for example, Amazon RDS (for PostgreSQL) or Amazon ElastiCache
(for Redis).
