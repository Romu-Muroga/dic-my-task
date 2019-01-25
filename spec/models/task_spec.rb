require "rails_helper"

RSpec.describe Task, type: :model do

  before do
    @user1 = FactoryBot.create(:user)
    @label1 = FactoryBot.create(:label)
  end

  it "titleが空ならバリデーションが通らない" do
    task = Task.new(title: "", content: "失敗テスト")
    expect(task).not_to be_valid#be_validでvalid?メソッドを呼んで、それが返す値が（真 = true）ではない（not_to）ことを期待するテスト
  end

  it "contentが空ならバリデーションが通らない" do
    task = Task.new(title: "失敗テスト", content: "")
    expect(task).not_to be_valid
  end

  it "全ての内容が記載されていればバリデーションが通る" do
    task = Task.new(title: "成功テスト", content: "成功テスト", end_time_limit: DateTime.now, status: "waiting", priority: "row", user: @user1 )#user_id:とするとエラーになる
    expect(task).to be_valid#be_validでvalid?メソッドを呼んで、それが返す値が（真 = true）である（to）ことを期待するテスト
  end

  it "titleのみの検索ができるかテスト" do
    task1 = Task.create!(title: "当たり", content: "あああ", end_time_limit: DateTime.now, status: "waiting", user: @user1)
    task2 = Task.create!(title: "当たり", content: "いいい", end_time_limit: DateTime.now, status: "working", user: @user1)
    tasks = Task.title_search("当たり")
    expect(tasks).to include task1, task2
  end

  it "statusのみの検索ができるかテスト" do
    task1 = Task.create!(title: "当たり", content: "当たり", end_time_limit: DateTime.now, status: "waiting", user: @user1)
    task2 = Task.create!(title: "ハズレ", content: "ハズレ", end_time_limit: DateTime.now, status: "working", user: @user1)
    tasks = Task.status_search("waiting")
    expect(tasks).to include task1
  end

  it "labelのみの検索ができるかテスト" do
    task1 = Task.create!(title: "当たり", content: "当たり", end_time_limit: DateTime.now, status: "waiting", user: @user1)
    task2 = Task.create!(title: "ハズレ", content: "ハズレ", end_time_limit: DateTime.now, status: "working", user: @user1)
    TaskLabel.create!(task_id: task1.id, label_id: @label1.id)
    label_tasks = Label.label_search(@label1.id)
    tasks = label_tasks.current_user_narrow_down(@user1.id)
    expect(tasks).to include task1
  end

  it "titleとstatusとlabelの全てに値が入っていた場合の検索ができるかテスト" do
    task1 = Task.create!(title: "当たり", content: "当たり", end_time_limit: DateTime.now, status: "waiting", user: @user1)
    task2 = Task.create!(title: "ハズレ", content: "ハズレ", end_time_limit: DateTime.now, status: "working", user: @user1)
    TaskLabel.create!(task_id: task1.id, label_id: @label1.id)
    label_tasks = Label.label_search(@label1.id)
    tasks = label_tasks.title_status_current_user_search(task1.title, task1.status, @user1.id)
    expect(tasks).to include task1
  end
end
