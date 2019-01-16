require 'rails_helper'

RSpec.describe User, type: :model do
  it "nameが101文字以上または空ならバリデーションが通らない" do
    user = User.new(name: "", email: "test_user@dic.com", password: "password")
    expect(user).not_to be_valid
    user = User.new(name: "#{"a" * 101}", email: "test_user@dic.com", password: "password")
    expect(user).not_to be_valid
  end

  it "emailが201文字以上または空ならバリデーションが通らない" do
    user = User.new(name: "test_user", email: "", password: "password")
    expect(user).not_to be_valid
    user = User.new(name: "test_user", email: "#{"a" * 200}@dic.com", password: "password")
    expect(user).not_to be_valid
  end

  it "emailの表記が正しくなかったときバリデーションが通らない" do
    user = User.new(name: "test_user", email: ",[]./_-]^@dic.com", password: "password")
    expect(user).not_to be_valid
  end

  it "emailが既に存在していたらバリデーションが通らない" do
    User.create!(name: "sample", email: "test_user@dic.com", password: "password")
    user = User.new(name: "test_user", email: "test_user@dic.com", password: "password")
    expect(user).not_to be_valid
  end

  it "passwordが7文字以下または201文字以上または空ならバリデーションが通らない" do
    user = User.new(name: "test_user", email: "test_user@dic.com", password: "")
    expect(user).not_to be_valid
    user = User.new(name: "test_user", email: "test_user@dic.com", password: "#{"a" * 7}")
    expect(user).not_to be_valid
    user = User.new(name: "test_user", email: "test_user@dic.com", password: "#{"a" * 201}")
    expect(user).not_to be_valid
  end
end
