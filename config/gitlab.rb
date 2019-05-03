#
# NOTE - This file was designed for testing purposes only, and is not suitable
# for a production deployment.
#

# Be sure to set to the URL of the Stoplight application front-end, _not_ the
# URL for GitLab
external_url 'http://localhost:3100'

# initial root user password, only valid on first boot
gitlab_rails['initial_root_password'] = "password"

# gitlab_rails['env'] = {
#   'DATABASE_URL' => 'postgresql://stoplight:stoplight@postgres:5432/stoplight_development'
# }

redis['enable'] = false
# redis['enable'] = true
# redis['bind'] = '0.0.0.0'
# redis['port'] = 6379

gitlab_rails['redis_host'] = "redis"
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_database'] = 0
gitlab_rails['redis_password'] = "toh4ahcuXoo1Pa4aeth2rai7thux"

postgresql['enable'] = false
# postgresql['enable'] = true
# postgresql['listen_address'] = '0.0.0.0'
# postgresql['port'] = 5432
# postgresql['data_dir'] = "/var/opt/gitlab/postgresql/data"

gitlab_rails['db_database'] = "stoplight"
gitlab_rails['db_host'] = "postgres"
gitlab_rails['db_port'] = 5432
gitlab_rails['db_username'] = "stoplight"
gitlab_rails['db_password'] = "veetah9pum9ciesee0aiWeegoh3ve2Ya"
gitlab_rails['db_sslmode'] = nil

nginx['enable'] = true
# set nginx listening port explicitly, otherwise it will be set automatically by
# the external_url variable above
nginx['listen_port'] = 8000
nginx['listen_addresses'] = ['0.0.0.0']
nginx['listen_https'] = false
nginx['proxy_set_headers'] = {
  "X-Forwarded-Proto" => "http",
  "X-Forwarded-Ssl" => "off"
}

# postgresql['custom_pg_hba_entries'] = {
#     gitlab: [
#         {
#         type: 'host',
#         database: 'all',
#         user: 'all',
#         cidr: '0.0.0.0/0',
#         method: 'trust'
#         }
#     ]
# }
