# このアプリについて
タスクを管理することができるアプリです。
# 機能一覧
- 自分のタスクを簡単に登録
- タスクに終了期限を設定
- タスクに優先順位をつけることができます。
- ステータス（未着手・着手・完了）を管理
- ステータスでタスクを絞り込むことができます。
- タスク名などで指定のタスクを検索
- タスク一覧を見ることができ、一覧画面では（優先順位、終了期限などを元にして）ソートすることも可能です。
- タスクにラベルなどをつけて分類することができます。
- ユーザ登録し、自分が登録したタスクだけを見ることができます。
- ユーザの管理機能

# バージョン
- Ruby 2.5.3
- Rails 5.2.2
- PostgreSQL 10.5

# データベース
### usersテーブル
##### モデル名：User
|カラム名|データ型|limit|null|default|
|---|---|---|---|---|
|name|string|100文字|false|
|email|string|200文字|false|
|password_digest|string|200文字|false|
|admin|boolean|なし|false|false|

### tasksテーブル
##### モデル名：Task
|カラム名|データ型|limit|null|default|
|---|---|---|---|---|
|title|string|100文字|false|なし|
|content|string|500文字|false|なし|
|end_time_limit|datetime|なし|false|'now()'|
|priority|integer|なし|false|1|
|status|integer|なし|false|0|
|user_id|bigint|なし|false|なし|

### labelsテーブル
##### モデル名：Label
|カラム名|データ型|limit|null|default|
|---|---|---|---|---|
|name|string|100文字|false|なし|
|user_id|bigint|なし|false|なし|

### task_labelsテーブル（中間テーブル）
##### モデル名：TaskLabel
|カラム名|データ型|limit|null|default|
|---|---|---|---|---|
|task_id|bigint|なし|false|なし|
|label_id|bigint|なし|false|なし|

# Herokuにデプロイする手順
1. デプロイする前にアセットプリコンパイルをします。
```
$ rails assets:precompile RAILS_ENV=production
```
2. 次に、コミットをします。
```
$ git add -A
$ git commit -m "コミットメッセージ"
```
3. 次に、Herokuに新しいアプリケーションを作成します。
```
$ heroku create
```
これで、Heroku上に新しいアプリケーションが作成されました。

4. 次に、Herokuにデプロイをします。
```
$ git push heroku master
```
5. 次に、データベースの移行を行います。
```
$ heroku run rails db:migrate
```
6. ブラウザで以下のURLにアクセスすれば起動します。  
https://safe-plateau-44552.herokuapp.com/
