require "rails_helper"

RSpec.describe Task, type: :model do

  it "titleが空ならバリデーションが通らない" do
    task = Task.new(title: "", content: "失敗テスト")
    expect(task).not_to be_valid#be_validでvalid?メソッドを呼んで、それが返す値が（真 = true）ではない（not_to）ことを期待するテスト
  end

  it "contentが空ならバリデーションが通らない" do
    task = Task.new(title: "失敗テスト", content: "")
    expect(task).not_to be_valid
  end

  it "titleとcontentに内容が記載されていればバリデーションが通る" do
    task = Task.new(title: "成功テスト", content: "成功テスト")
    expect(task).to be_valid#be_validでvalid?メソッドを呼んで、それが返す値が（真 = true）である（to）ことを期待するテスト
  end
end
