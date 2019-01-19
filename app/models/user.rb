class User < ApplicationRecord
  # バリデーション
  before_validation { email.downcase! }#保存する前にメールアドレスの値を小文字に変換
  validates :name, presence: true, length: { in: 1..100 }
  validates :email, presence: true, length: { in: 1..200 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :password, presence: true, length: { in: 8..200 }
  #validates :admin, presence: true
  before_update :admin_users_last_update?
  before_destroy :admin_users_last_destroy?
  # パスワード管理
  has_secure_password
  # セキュアにハッシュ化したパスワードを、データベース内のpassword_digestというカラムに保存する
  # 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される
  # authenticateメソッドが使えるようになる (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド)
  # アソシエーション
  has_many :tasks, dependent: :destroy#関連するモデルも削除する（「dependent：依存している」という意味）
  # 管理者権限を持つユーザーが残り１名になっているか確認
  private
  def admin_users_last_update?
    # 管理者権限を持つユーザーが１名かつ@userが管理者権限を持つユーザーと完全一致していたらthrow(:abort)でエラーを起こす。
    admin_users = User.where(admin: true)
    throw(:abort) if admin_users.count == 1 && admin_users.first === self
  end

  def admin_users_last_destroy?
    # 管理者権限を持つユーザーが１名かつ@userが管理者権限を持っていたらthrow(:abort)でエラーを起こす。
    throw(:abort) if User.where(admin: true).count == 1 && self.admin?
  end
end
