# ubuntu-rdp
リモートデスクトップ接続とSSH接続が可能なUbuntu:18.04のコンテナです。

<img src="https://user-images.githubusercontent.com/25416202/80746459-e432ad80-8b5c-11ea-9f21-e9b773c55d70.PNG" alt="desktop_image" width="500"/>

このコンテナは以下で構成しています。  
- OS：Ubuntu:18.04
  - 日本語入力環境対応（Mozc）
  - sudo権限付きuser作成済み（ID：my-ubuntu、PASS：my-Password）
- デスクトップ環境：Xfce
  - xfce4-goodiesインストール済み
  - gitやnanoエディタ等の基本ツールをインストール済み
- リモートデスクトップサーバー：Xrdp
  - リモート越しの双方向のclipborad共有に対応
  - マルチディスプレイに対応
  - rootログイン拒否設定済み
- SSHサーバー：openssh-server
  - 公開鍵設定済み（秘密鍵は[こちら](https://github.com/Rosyuku/ubuntu-rdp/blob/master/config/ssh/.ssh/id_rsa)）
  - パスワードログイン拒否設定済み
  - rootログイン拒否設定済み

ユーザ名等の設定を変更する場合は、[設定ファイル](https://github.com/Rosyuku/ubuntu-rdp/blob/master/.env)を書き換えてDocker-composeし直していただくのが簡単です。

## Usage
imageをpullしてご利用いただく場合、以下のコマンドで実行できます。  
（以下の例では13389portでリモートデスクトップ接続、10022portでSSH接続が可能です。ポートはお好きに変更いただいて構いません。）
```
docker run --rm -it -p 13389:3389 -p 10022:22 --shm-size=256m rosyuku/ubuntu-rdp:0.1.1
```

### リモートデスクトップ接続
リモートデスクトップ接続のユーザー名とパスワードはそれぞれ以下の通りです。  
（ID：my-ubuntu、PASS：my-Password）

<img src="https://user-images.githubusercontent.com/25416202/80747460-74bdbd80-8b5e-11ea-91bd-4644aea3ea95.PNG" alt="rdp_connect" width="300"/>

### SSH接続
SSH接続のユーザー名と秘密鍵はそれぞれ以下の通りです。  
（ID：my-ubuntu、秘密鍵：https://github.com/Rosyuku/ubuntu-rdp/blob/master/config/ssh/.ssh/id_rsa）

<img src="https://user-images.githubusercontent.com/25416202/80747459-738c9080-8b5e-11ea-8bcf-04ec67d25871.PNG" alt="ssh_connect" width="300"/>

## Build
本コンテナを以下のような用途でご利用される場合には  
セキュリティ的／機能的観点から設定を変更してDocker-composeするようにしてください。
- Publicからアクセスできる環境（≒コンテナにlocalhost以外から接続）で用いる場合
- ユーザー名やパスワード等の各種設定（ポート以外）を変更して用いたい場合

### Build手順
まず、GithubよりリポジトリをCloneしてください。
```
git clone https://github.com/Rosyuku/ubuntu-rdp.git
```
次にubuntu-rdp/.envファイルを開いて以下の設定を変更します。
```
root_password=super            #rootのパスワード
user_name=my-ubuntu            #作成するuserのユーザ名
user_password=my-Password      #作成するuserのパスワード
container_name=ubuntu-desktop  #作成するコンテナの名前
host_name=Challenger           #Ubuntuのホスト名
shm_size=256m                  #一時ファイル領域
RDPport=33890                  #リモートデスクトップ接続のport
SSHport=22000                  #SSH接続のport
```
リモートデスクトップやSSHの設定は[config内](https://github.com/Rosyuku/ubuntu-rdp/tree/master/config)の設定ファイルを変更してください。

最後に以下等のコマンドでビルドします。
```
Docker-compose up --build
```
