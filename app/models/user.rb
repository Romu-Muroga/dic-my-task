class User < ApplicationRecord
  # バリデーション
  before_validation { email.downcase! }#保存する前にメールアドレスの値を小文字に変換
  validates :name, presence: true, length: { in: 1..100 }
  validates :email, presence: true, length: { in: 1..200 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :password, presence: true, length: { in: 8..200 }
  # パスワード管理
  has_secure_password
  # セキュアにハッシュ化したパスワードを、データベース内のpassword_digestというカラムに保存する
  # 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される
  # authenticateメソッドが使えるようになる (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド)
  # アソシエーション
  has_many :tasks
end
