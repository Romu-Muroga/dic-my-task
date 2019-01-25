### このアプリについて
タスクを管理することができるアプリです。
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

### 要件
- Ruby 2.5.3
- Rails 5.2.2
- PostgreSQL 10.5

### データベース
###### usersテーブル
- モデル名：Userモデル
  - nameカラム => string型（１００文字以下）
  - emailカラム　=> string型（２００文字以下）、index、unique
  - password_digestカラム => string型（８文字以上２００文字以下）
  - adminカラム => boolean型、defalt: false

###### tasksテーブル
- モデル名：Taskモデル
  - titleカラム => string型（１００文字以下）、index
  - contentカラム => string型（５００文字以下）
  - end_time_limitカラム => datetime型、defalt: 現在時刻
  - priorityカラム => integer型、defalt: 中
  - statusカラム => integer型、defalt: 未着手、index
  - user_idカラム => bigint型、index

###### labelsテーブル
- モデル名：Labelモデル
  - nameカラム => string型（１００文字以下）、index
  - user_idカラム => bigint型、index

###### task_labelsテーブル（中間テーブル）
- モデル名：TaskLabelモデル
  - task_idカラム => bigint型、index
  - label_idカラム => bigint型、index
  - [task_id, label_id] => unique

### Herokuにデプロイする手順
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
6. アプリ名を確認する方法
```
$ heroku config
```
7. これで、ブラウザで以下のURLにアクセスすれば起動するはずです。  
https://アプリ名.herokuapp.com/
