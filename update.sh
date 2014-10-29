#!/bin/bash

function abort()
{
    echo $'\e[1;31merror:' $1 $'\e[0m' >&2
    exit 1
}

[[ -n "$druid_coordinator" && -n "$druid_broker" && -n "$druid_historical_1" && -n "$druid_overlord" && -n "$druid_middleManager" ]] || abort "exports not set up"

scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $druid_coordinator:/usr/local/druid-services/config/coordinator/runtime.properties coordinator.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $druid_broker:/usr/local/druid-services/config/broker/runtime.properties broker.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $druid_historical_1:/usr/local/druid-services/config/historical/runtime.properties historical.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $druid_overlord:/usr/local/druid-services/config/overlord/runtime.properties overlord.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $druid_middleManager:/usr/local/druid-services/config/middleManager/runtime.properties middleManager.properties

for I in *.properties; do
	perl -pi -e 's/druid.s3.accessKey=.*/druid.s3.accessKey=XXXXXXXXXXXX/g' $I
	perl -pi -e 's/druid.s3.secretKey=.*/druid.s3.secretKey=xxxxxxxxxxxxxxxxxxxx/g' $I
	perl -pi -e 's/druid.storage.bucket=.*/druid.storage.bucket=s3-bucket/g' $I
	perl -pi -e 's/druid.indexer.logs.s3Bucket=.*/druid.indexer.logs.s3Bucket=s3-bucket/g' $I
done
