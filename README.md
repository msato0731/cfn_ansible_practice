## 環境構築
1. コンソールにログインし、キーペアを作成。「~/.ssh」に配置。パーミッションを変更しておく
```
chmod 600 <keyファイル>
```
1. s3パケットを作成し、テンプレートを配置しておく
1. cloudformation実行
    - Stack.ymlのs3のパスを変更する
    - rdsのパスワードは、「password」にする
    - snsのメールアドレスは、「test@example.com」にする
1. SNSの承認メールを承諾する
1. ~/.ssh/configを書き換える
  - keyfile
  - hostname
1. sshでWebサーバにログインできることを確認しておく
1. スクリプトの以下の箇所を編集する
  - cpu_send.sh SNSトピックARN
  - cpu_recend.sh SQSキュー名

1. ansibleを実行する
```
ansible-playbook playbook.yml -C
ansible-playbook playbook.yml
```
## 練習1
VPC環境の構築をしてもらいます。
２つのAZに分けてサブネット４つを作成し、
その２つをPublic、２つをPrivateとします。
また、RDSでMySQLをMultiAZで起動します。
ELB配下に２台置きWebサーバはApacheを置きます。
セキュリティグループは80番と22番のみ公開します。


## 練習１確認方法
1. 各種パラメータ・リソースチェック
1. ALBのIPアドレスを入力し、画面とログから振り分けできていることを確認する。
```
sudo tail -f  /var/log/httpd/access_log
```

1. mysqlでRDSに接続できるか確認する
```
sudo yum install mysql
mysql -u DBUser -p -h <RDSのFQDN>
```

### 練習２
IAM RoleでPowerUserに設定したEC2から、
１分に１回CPU使用率をSNSへ通知をします。
SNSではSQSとメールに分配します。
もうひとつのEC2（同様の権限）では、SQSをポーリングして
メッセージが届くとコマンドラインに表示します。

### 練習2確認方法
1. IAMロール確認
1. SNSとSQSの確認
1. web02で使用率が送られていることを確認する
```
tail -f /tmp/cpu_use.log
```


## 参考URL
SQS受信
https://qiita.com/tcsh/items/7781fe238df82fc030d2

CPU使用率
http://magazine.re-web.org/cpu-limit-check/

CPU使用率負荷
https://chariosan.com/2018/09/09/infra_it_cpumemdisk/

cron
https://qiita.com/katsukii/items/d5f90a6e4592d1414f99

SNSはfifoキューと互換性がない
https://docs.aws.amazon.com/ja_jp/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-subscribe-queue-sns-topic.html
