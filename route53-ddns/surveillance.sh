#!/bin/bash
# ####################
# make directory.
# ####################
if [ ! -d "/var/local/route53-ddns" ]; then
  mkdir -p /var/local/route53-ddns
fi
if [ ! -d "/tmp/route53-ddns/" ]; then
  mkdir -p /tmp/route53-ddns
fi

# ####################
# read config.
# ####################
awsprofile=$(sed -ne '/^AwsProfile/p' /etc/route53-ddns.conf | sed -ne 's/^.\+=//gp')
RecordName=$(sed -ne '/^RecordName/p' /etc/route53-ddns.conf | sed -ne 's/^.\+=//gp')
HostedZoneId=$(sed -ne '/^HostedZoneId/p' /etc/route53-ddns.conf | sed -ne 's/^.\+=//gp')

# ####################
# Scripts.
# ####################
touch /var/local/route53-ddns/ip
cip=$(curl ifconfig.io)
fip=$(cat ip)

if [[ -n $awsprofile ]]; then
  awsprofile="--profile ${awsprofile}"
fi

if [[ $cip = $fip ]]; then
  echo matche!
else
  echo $cip > /var/local/route53-ddns/ip
  cip=$(perl -pe 's/\n/ /' /var/local/route53-ddns/ip)

  cat << EOJ > "/tmp/route53-ddns/route53.json"
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

  aws route53 change-resource-record-sets --hosted-zone-id $HostedZoneId --change-batch file:///tmp/route53-ddns/route53.json $awsprofile
  rm /tmp/route53-ddns/route53.json
fi
