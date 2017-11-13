#!/bin/bash

start=$(date +%s)
# Use 1 to signify success, so that we can use count() and sum() to identify when backups fail
result="1"
docker exec \
       gitlab-1 \
       gitlab-rake gitlab:backup:create \
       DIRECTORY={{ gitlab_s3_directory }} \
       CRON=1
if [[ "$?" != "0" ]]; then
    # Failure, set to 0
    result="0"
fi
end=$(date +%s)

curl -XPOST \
     'https://metrics.stoplight-dev.com:8932/write?db=telegraf' \
     --data-binary "gitlab_backups,environment={{ app_environment }},host=$(hostname),directory={{ gitlab_s3_directory }} result=${result}i,duration=$(( $end - $start ))i"
