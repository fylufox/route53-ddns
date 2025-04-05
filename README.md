# route53-ddns
LinxuサーバのパブリックIPを取得し、Route53で疑似DDNSを実装するスクリプト。
# config
`/etc/route53-ddns.conf`にconfファイルを配置
```
# (option) using aws profile name.
AwsProfile=default
# (require) Route53 RecordName 
RecordName=exanmple.com
# (require) Route53 HostedZoneId
HostedZoneId=xxxx
```