#!/bin/bash -xe

for ami_with_region in $(jq -r .builds[0].artifact_id manifest.json | sed 's/,/\n/g') ; do
    now=$(date --utc '+%Y-%m-%dT%H:%M:%SZ')
    echo $ami_with_region | (
        IFS=: read region ami
        aws dynamodb put-item \
            --table-name AMIs \
            --item "{\"region\": {\"S\": \"${region}\"},\"ami\": {\"S\": \"${ami}\"},\"date\": {\"S\": \"${now}\"},\"ami_type\": {\"S\": \"eks\"}}"
        )
done