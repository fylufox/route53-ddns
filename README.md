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
# systemd
`/etc/systemd/system`に`/systemd/route53-ddns.service`と`/systemd/route53-ddns.timer`を配置  
```
sudo systemctl start route53-ddns.timer
sudo systemctl enable route53-ddns.timer
```