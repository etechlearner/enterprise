#!/usr/bin/env python3
#
# This script can be used to set all users in a GitLab installation as "Guests"
# (ie, read-only) for all organizations on the system. Please note that this
# gives all users on the system read-access to all group/organization-owned
# projects on the system. Personal projects (projects owned by a single user)
# are not affected.
#
# To use this script, set two environment variables:
#
#   * GITLAB_URL - The full URL to the GitLab instance you would like to run
#     against. For example: http://gitlab.example.com:8080
#
#   * ACCESS_TOKEN - An administrative access token for accessing the GitLab
#     API. This can be any access token for an administrative user.
#
# Please contact customers@stoplight.io with any questions or concerns regarding
# the usage or contents of this script.
#
import requests
import sys
import os
from threading import Thread
from queue import Queue

api_host = os.getenv("GITLAB_URL")
if api_host == None:
    raise Exception("No GITLAB_URL environment variable set.")

access_token = os.getenv("ACCESS_TOKEN")
if access_token == None:
    raise Exception("No ACCESS_TOKEN environment variable set.")

access_level = 10  # = guest/reader access
api_host += "/api/v4"
headers = {
    "Private-Token": access_token
}

workers = 20
queue = Queue(workers * 2)


def get_users():
    users = []
    page = 1
    while (True):
        r = requests.get(
            api_host + "/users", params={'per_page': 100, 'page': page}, headers=headers)
        r.raise_for_status()
        data = r.json()
        if len(data) == 0:
            break
        users += data
        page += 1
    print("Retrieved {} users.".format(len(users)))
    return users


def get_groups():
    groups = []
    page = 1
    while (True):
        r = requests.get(api_host + "/groups",
                         params={'per_page': 100, 'page': page}, headers=headers)
        r.raise_for_status()
        data = r.json()
        if len(data) == 0:
            break

        for group in data:
            if group['parent_id'] == None:
                # only retrieve top-level groups (not sub-groups)
                groups.append(group)

        page += 1

    return groups


def get_group_members(group):
    members = []
    page = 1
    while (True):
        r = requests.get(api_host + "/groups/" + str(group['id']) + '/members', params={
                         'per_page': 100, 'page': page}, headers=headers)
        r.raise_for_status()
        data = r.json()
        if len(data) == 0:
            break
        members += data
        page += 1
    return members


def add_user_to_group(user, group):
    print('Adding user ' + user['username'] + ' (' +
          str(user['id']) + ')' + ' to group ' + group['name'])
    r = requests.post(
        api_host + '/groups/' + str(group['id']) + '/members',
        headers=headers,
        data={
            'user_id': user['id'],
            'access_level': access_level,
        })
    r.raise_for_status()


def worker():
    while True:
        item = queue.get()
        try:
            add_user_to_group(item[0], item[1])
        except Exception as e:
            print("Exception encountered:", e)
        queue.task_done()


if __name__ == '__main__':
    users_by_usernames = {}
    users = get_users()
    for u in users:
        # index users by username for quick lookup
        users_by_usernames[u['username']] = u
    groups = get_groups()
    for group in groups:
        # for each group, retrieve the members
        members = get_group_members(group)
        members_by_username = {}
        for m in members:
            # index members by username for quick lookup
            members_by_username[m['username']] = m

        threads = []
        for i in range(workers):
            t = Thread(target=worker)
            t.daemon = True
            t.start()
            threads.append(t)

        for username in users_by_usernames:
            if not members_by_username.get(username):
                queue.put([users_by_usernames[username], group])

        queue.join()
