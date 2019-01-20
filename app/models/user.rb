class User < ApplicationRecord
  # バリデーション
  before_validation { email.downcase! }#バリデーションする前にメールアドレスの値を小文字に変換
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
  # TODO: admin_users_last_update?メソッドを外部から呼び出すにはどうしたらいいか？
  # def admin_users_last?
  #   admin_users = User.where(admin: true)
  #   true if (admin_users.count == 1 && admin_users.first == self) && !(self.admin?)
  # end

  private
  def admin_users_last_update?
    # （管理者権限を持つユーザーが１名かつself（@user）が管理者権限を持つユーザーとIDが一致※1）かつ（self（@user）が管理者権限を持っていなかったら）->true
    # のとき、throw(:abort)でrollbackを起こす。
    # ※1 ===で完全一致の検証はできない。ActiveRecordで、オブジェクト同士を==で比較した場合、全属性が同値かどうかは検証しない。==はidが同値かどうかを検証。
    admin_users = User.where(admin: true)
    # (errors.add(:admin, I18n.t("errors.messages.admin")); throw(:abort)) if (admin_users.count == 1 && admin_users.first == self) && !(self.admin?)
    # と書いても同じ処理だけど可読性が低い。
    if (admin_users.count == 1 && admin_users.first == self) && !(self.admin?)
      errors.add(:admin, I18n.t("errors.messages.admin"))
      throw(:abort)
    else
      true
    end
  end

  def admin_users_last_destroy?
    # 管理者権限を持つユーザーが１名かつ@userが管理者権限を持っていたら ->trueのとき、throw(:abort)でrollbackを起こす。
    throw(:abort) if User.where(admin: true).count == 1 && self.admin?
  end
end
