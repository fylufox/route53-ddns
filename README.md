# route53-ddns
LinxuサーバのパブリックIPを取得し、Route53で疑似DDNSを実装するスクリプト。
# config
`/etc/route53-ddns.conf`にconfファイルを配置
```
AwsProfile=default
RecordName=exanmple.com
HostedZoneId=xxxx
```