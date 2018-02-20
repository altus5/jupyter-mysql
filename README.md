# Jupyter Notebook の使い方（MySQL編）

Jupyter NotebookをDockerコンテナで実行します。  
jupyterが提供しているbase-notebookというDockerイメージに、
SQLを実行するための `ipython-sql` モジュールと、
mysqlのclientモジュールを追加しています。

また、サンプルDBのmysqlコンテナも、docker-composeで一緒に起動するので、すぐに試してみることができます。（1件だけの簡単なデータも登録されています）

## コンテナ起動

docker-compose up して起動したら、ターミナルに、こんな感じのログが流れます。
```
jupyter_1  | [C 08:59:53.632 NotebookApp]
jupyter_1  |
jupyter_1  |     Copy/paste this URL into your browser when you connect for the first time,
jupyter_1  |     to login with a token:
jupyter_1  |         http://localhost:8888/?token=3f1b38de7b1f3a74238ac85408387353760b06a14673f7fd
jupyter_1  | [I 09:01:03.299 NotebookApp] 302 GET / (192.168.99.1) 1.44ms
jupyter_1  | [I 09:01:03.305 NotebookApp] 302 GET /tree? (192.168.99.1) 1.06ms

```
ログの中にある URL から、token= の値をコピーしてください。  
※`docker-compose up -d`で起動した場合は、`docker-compose logs`でログを確認してください。

## Jupyter Notebookを起動

Jupyter NotebookはWEBエディタなので、ブラウザで起動します。  
dockerを起動したホストOSのIPが192.168.99.100だとします。  
以下のアドレスでアクセスしてください。
```
http://192.168.99.100:18888/
```
最初の画面で、token の入力が求められるので、コピーした token を入力してください。

ファイル一覧が表示されたと思います。

## 使ってみる

`work`ディレクトリ内の`quick-start.ipynb`を開いてください。
これは、サンプルで作成してあるノートです。

先頭部分のブロック（「Jupyter Notebook の使い方・・・」と書かれている部分）は、マークダウンのブロックになっています。自由に文章を記入できます。  

`In [x]` とついている部分は、SQLを実行するコードのブロックになります。  
とりあえず、「SQLを使うためのモジュールのロード」のブロックに、カーソルを持って行って、CTRL+ENTERしてください。実行されて、SQLモジュールが読み込まれました。  

次に、「DBに接続」のブロックでも、CTRL+ENTERしてください。DBに接続されます。ここでの接続先は、docker-composeで同時に起動されているmysqlのコンテナを際しています。本気使いするときには、この接続先を変更してください。変更方法は直観的にわかると思います。  
※`?charset=utf8mb4`は付けておかないと文字化けしました。

あとは、自由にSQLを実行してみてください。

