# requireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしている。
require "rails_helper"

# RSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能（一覧・作成日時の降順・詳細・終了期限のソート・優先順位でソート）", type: :feature do
  # background（Rspec -> before）を使って、「タスク管理機能（一覧と作成日時の降順）」というカテゴリの中で使われるデータを共通化
  background do
    @task1 = FactoryBot.create(:task)
    @task2 = FactoryBot.create(:second_task)
    @task3 = FactoryBot.create(:third_task)
  end
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
    # Task.create!(title: 'test_task_01', content: 'testtesttest')
    # Task.create!(title: 'test_task_02', content: 'samplesample')
    # 上記２行はbackground do ~ end内で共通化したため、コメントアウト

    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path

    # visitした（到着した）expect(page)に（タスク一覧ページに）「testtesttest」「samplesample」という文字列が
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
    expect(page).to have_content "testtesttest"
    expect(page).to have_content "samplesample"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    visit tasks_path
    # all メソッドでは条件に合致した要素の配列が返ってくる
    all(".panel")[0].click_link "詳細"
    expect(page).to have_content "test_task_03"

    visit tasks_path

    all(".panel")[1].click_link "詳細"
    expect(page).to have_content "test_task_02"
  end

  scenario "タスク詳細のテスト" do
    visit task_path(@task1.id)
    expect(page).to have_content "test_task_01", "testtesttest"
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

end

RSpec.feature "タスク管理機能（作成）", type: :feature do

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

    #「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理
    click_on "登録する"

    # 実際の状況を確認したい箇所にsave_and_open_pageメソッドをさし挟む。
    # このテストの場合「タスクが保存された後、タスク詳細ページに行くとどうなるのか」を確認するため
    # click_on '登録' の直後に save_and_open_page を挟んでいる。
    # save_and_open_page

    # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
    # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
    # タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコード
    expect(page).to have_content "タスク名test"
    expect(page).to have_content "タスク詳細test"
    expect(page).to have_content "2018/12/25 15:28"
    # expect(page).to have_content "2019/01/01 00:00"
    expect(page).to have_content "未着手"
    expect(page).to have_content "中"
  end
end
