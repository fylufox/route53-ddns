#!/bin/bash
# ####################
# read config.
# ####################
awsprofile=$(sed -ne '/AwsProfile/p' route53-ddns.conf | sed -ne 's/^.\+=//gp')
RecordName=$(sed -ne '/RecordName/p' route53-ddns.conf | sed -ne 's/^.\+=//gp')
HostedZoneId=$(sed -ne '/HostedZoneId/p' route53-ddns.conf | sed -ne 's/^.\+=//gp')

# ####################
# Scripts.
# ####################
touch ip
cip=$(curl ifconfig.io)
fip=$(cat ip)

if [[ $cip = $fip ]]; then
  echo matche!
else
  echo $cip > ip
  cip=$(perl -pe 's/\n/ /' ip)

  cat << EOJ > "json"
  {
    "Comment" : "",
    "Changes" : [
      {
        "Action" : "UPSERT",
        "ResourceRecordSet" : {
          "Name" : "$RecordName",
          "Type" : "A",
          "TTL" : 300,
          "ResourceRecords" : [
            {
              "Value": "$cip"
            }
          ]
        }
      }
    ]
  }
EOJ

  aws route53 change-resource-record-sets --hosted-zone-id "${HostedZoneId}" --change-batch file://json --profile "${awsprofile}"
  rm json
fi