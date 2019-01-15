class User < ApplicationRecord
  validates :name, presence: true, length: { in: 1..100 }
  validates :email, presence: true, length: { in: 1..200 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :password_digest, presence: true, length: { in: 8..200 }

  has_many :tasks
end
