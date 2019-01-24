# All Users, All Orgs

The script in this directory can be used to set all users in a GitLab
installation as "Guests" (ie, read-only) for all organizations on the system.

> Please note that this gives all users on the system read-access to all
> group/organization-owned projects on the system. Personal projects (projects
> owned by a single user) are not affected.

There are currently two variations of this script: one for Python 2
(`all_users_all_orgs.py2.py`) and one for Python 3
(`all_users_all_orgs.py3.py`). There are no functional differences apart from
modules in use between the two scripts, however we recommend using the Python 3
version if possible.

To use this script, set two environment variables:

- GITLAB_URL - The full URL to the GitLab instance you would like to run
  against. For example: http://gitlab.example.com:8080

- ACCESS_TOKEN - An administrative access token for accessing the GitLab
  API. This can be any access token for an administrative user.

Please contact customers@stoplight.io with any questions or concerns regarding
the usage or contents of this script.
