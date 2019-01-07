# デフォルト言語を日本語に設定
# Railsのデフォルトのロケール読み込みメカニズムでは、ネストした辞書に含まれるロケールファイルを読み込まない。
# 従って、これらが読み込まれるようにするためには以下のようにRailsで明示的に指定する必要がある。
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
# 以下の記述の順番を入れ替えるとrails sした時にTraceback (most recent call last):が起こる
I18n.config.available_locales = :ja
I18n.default_locale = :ja
