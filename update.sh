#!/bin/bash

scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $DRUID_COORDINATOR:/usr/local/druid-services/config/coordinator/runtime.properties coordinator.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $DRUID_BROKER:/usr/local/druid-services/config/broker/runtime.properties broker.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $DRUID_HISTORICAL_1:/usr/local/druid-services/config/historical/runtime.properties historical.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $DRUID_OVERLORD:/usr/local/druid-services/config/overlord/runtime.properties overlord.properties
scp -i $WHIRR_PEM -o "UserKnownHostsFile /dev/null" -o StrictHostKeyChecking=no $DRUID_MIDDLEMANAGER:/usr/local/druid-services/config/middleManager/runtime.properties middleManager.properties

for I in *.properties; do
	perl -pi -e 's/druid.s3.accessKey=.*/druid.s3.accessKey=XXXXXXXXXXXX/g' $I
	perl -pi -e 's/druid.s3.secretKey=.*/druid.s3.secretKey=xxxxxxxxxxxxxxxxxxxx/g' $I
	perl -pi -e 's/druid.storage.bucket=.*/druid.storage.bucket=s3-bucket/g' $I
	perl -pi -e 's/druid.indexer.logs.s3Bucket=.*/druid.indexer.logs.s3Bucket=s3-bucket/g' $I
done
