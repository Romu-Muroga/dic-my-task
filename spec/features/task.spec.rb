# requireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしている。
require "rails_helper"

# RSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  # ユーザー
  user1 = FactoryBot.create(:user)
  user2 = FactoryBot.create(:second_user)
  # タスク
  task1 = FactoryBot.create(:task, user: user1)
  task2 = FactoryBot.create(:second_task, user: user1)
  task3 = FactoryBot.create(:third_task, user: user1)
  # ラベル
  label1 = FactoryBot.create(:label)
  label2 = FactoryBot.create(:second_label)
  label3 = FactoryBot.create(:third_label)
  # 中間テーブル（task1はlabel1とlabel2を付けている）
  FactoryBot.create(:task_label, task: task1, label: label1)
  FactoryBot.create(:task_label, task: task1, label: label2)

  # background（Rspec -> before）を使って、「タスク管理機能」というカテゴリの中で使われるデータを共通化
  background do
    visit root_path
    fill_in "メールアドレス", with: 'test_user_01@dic.com'
    fill_in "パスワード", with: 'password'
    within ".form_outer" do
      click_on "ログイン"
    end
  end

  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "自分が作成したタスク一覧のテスト" do
    # 一覧画面という名前のついたボタンをクリック（タスク一覧ページに遷移する）
    click_on "一覧画面"

    # 遷移したexpect(page)に（タスク一覧ページに）「test_task_01」「test_task_02」「test_task_03」という文字列が
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テスト
    expect(page).to have_content "test_task_01"
    expect(page).to have_content "test_task_02"
    expect(page).to have_content "test_task_03"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    visit tasks_path
    # all メソッドでは条件に合致した要素の配列が返ってくる
    all(".panel")[0].click_link "詳細"
    expect(page).to have_content "test_task_03"

    visit tasks_path

    all(".panel")[1].click_link "詳細"
    expect(page).to have_content "test_task_02"

    visit tasks_path

    all(".panel")[2].click_link "詳細"
    expect(page).to have_content "test_task_01"
  end

  scenario "タスク詳細のテスト" do
    visit task_path(task1)
    expect(page).to have_content "test_task_01", "test"
  end

  scenario "タスクが終了期限で降順に並んでいるかのテスト" do
    visit tasks_path
    click_on "終了期限でソートする"

    all(".panel")[0].click_link "詳細"
    expect(page).to have_content "test_task_03"

    visit tasks_path
    click_on "終了期限でソートする"

    all(".panel")[1].click_link "詳細"
    expect(page).to have_content "test_task_02"

    visit tasks_path
    click_on "終了期限でソートする"

    all(".panel")[2].click_link "詳細"
    expect(page).to have_content "test_task_01"
  end

  scenario "タスクが優先順位で降順に並んでいるかのテスト" do
    visit tasks_path
    click_on "優先順位でソートする"

    all(".panel")[0].click_link "詳細"
    expect(page).to have_content "高"

    visit tasks_path
    click_on "優先順位でソートする"

    all(".panel")[1].click_link "詳細"
    expect(page).to have_content "中"

    visit tasks_path
    click_on "優先順位でソートする"

    all(".panel")[2].click_link "詳細"
    expect(page).to have_content "低"
  end

  scenario "ラベルのみで検索ができるかテスト" do
    visit tasks_path
    select "dive_into_code", from: "task_label_id"
    click_on "検索"
    expect(page).to have_content "test_task_01", "test"
  end

  scenario "タイトル・状態・ラベル全てを満たした検索ができるかテスト" do
    visit tasks_path
    fill_in "task_title", with: "test_task_01"
    select "未着手", from: "task_status"
    select "仕事", from: "task_label_id"
    click_on "検索"
    expect(page).to have_content "test_task_01", "未着手"
    expect(page).to have_content "仕事"
  end

  scenario "タスク作成のテスト" do
    # new_task_pathにvisitする（タスク登録ページに遷移する）
    visit new_task_path

    #「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理
    # withinで画面上に複数現れる要素を絞り込む
    within ".form_inner" do
      fill_in "タスク名", with: "タスク名test"
    end

    #「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理
    fill_in "タスク詳細", with: "タスク詳細test"

    # 「終了期限」というラベル名のセレクトボックスを選択する処理
    select "2018", from: "task[end_time_limit(1i)]"
    select "12月", from: "task[end_time_limit(2i)]"
    select "25", from: "task[end_time_limit(3i)]"
    select "15", from: "task[end_time_limit(4i)]"
    select "28", from: "task[end_time_limit(5i)]"
    # fill_in "終了期限", with: DateTime.new(2019,1,1,00,00,00)#タイムゾーンがUTC
    # fill_in "終了期限", with: DateTime.new(2019,1,1,00,00,00,"+09:00")
    # fill_in "終了期限", with: Time.zone.local(2019,1,1,00,00,00)#application.rbのタイムゾーンを使用

    # 「状態」というラベル名のセレクトボックスを選択す処理
    within ".form_inner" do
      select "未着手", from: "状態"
    end

    # 「優先順位」というラベル名のセレクトボックスを選択する処理
    select "中", from: "優先順位"

    # チェックボックスを選択
    check "task_label_ids_1"
    check "task_label_ids_2"
    check "task_label_ids_3"

    #「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理
    click_on "登録する"

    # 実際の状況を確認したい箇所にsave_and_open_pageメソッドをさし挟む。
    # このテストの場合「タスクが保存された後、タスク詳細ページに行くとどうなるのか」を確認するため
    # click_on '登録' の直後に save_and_open_page を挟んでいる。
    # save_and_open_page

    # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
    # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
    # タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコード
    within ".panel" do
      expect(page).to have_content "タスク名test"
      expect(page).to have_content "タスク詳細test"
      expect(page).to have_content "2018/12/25 15:28"
      # expect(page).to have_content "2019/01/01 00:00"
      expect(page).to have_content "未着手"
      expect(page).to have_content "中"
      expect(page).to have_content "dive_into_code"
      expect(page).to have_content "仕事"
      expect(page).to have_content "家事"
    end
  end

  scenario "タスク編集のテスト" do
    visit task_path(task1)
    click_on "編集"

    within ".form_inner" do
      fill_in "タスク名", with: "編集test"
    end

    fill_in "タスク詳細", with: "編集test"

    select "2020", from: "task[end_time_limit(1i)]"
    select "1月", from: "task[end_time_limit(2i)]"
    select "1", from: "task[end_time_limit(3i)]"
    select "00", from: "task[end_time_limit(4i)]"
    select "00", from: "task[end_time_limit(5i)]"

    within ".form_inner" do
      select "着手中", from: "状態"
    end

    select "高", from: "優先順位"

    # task1はdive_into_codeのラベルが付いているのでチェックを外す。
    uncheck "task_label_ids_1"

    click_on "更新する"

    within ".panel" do
      expect(page).to have_content "編集test"
      expect(page).to have_content "編集test"
      expect(page).to have_content "2020/01/01 00:00"
      expect(page).to have_content "着手中"
      expect(page).to have_content "高"
      expect(page).to_not have_content "dive_into_code"
      expect(page).to have_content "仕事"
    end
  end
end
