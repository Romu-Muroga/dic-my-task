require "rails_helper"

RSpec.feature "ユーザー管理機能", type: :feature do

  background do
    FactoryBot.create(:user)
    @user2 = FactoryBot.create(:second_user)
  end

  scenario "ログインできるかテスト" do
    visit root_path

    fill_in "メールアドレス", with: "test_user_01@dic.com"
    fill_in "パスワード", with: "password"

    within ".form_outer" do
      click_on "ログイン"
    end

    expect(page).to have_content "ログインに成功しました。"
  end

  scenario "ログインしていないのにタスクのページに飛ぼうとした場合、ログインページに遷移するかテスト" do
    visit root_path

    click_on "一覧画面"

    expect(page).to have_content "ログイン画面"
  end

  scenario "サインアップ(同時にログイン)できるかテスト" do
    visit new_user_path

    fill_in "氏名", with: "テスト太郎"
    fill_in "メールアドレス", with: "test_user@dic.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "password"

    click_on "登録する"

    expect(page).to have_content "「アカウント登録 + ログイン」しました。"
    expect(page).to have_content "テスト太郎"
    expect(page).to have_content "test_user@dic.com"
  end

  feature "ログインした状況", type: :feature do

    background do
      visit root_path
      fill_in "メールアドレス", with: "test_user_01@dic.com"
      fill_in "パスワード", with: "password"
      within ".form_outer" do
        click_on "ログイン"
      end
    end

    scenario "ログインしている時は、ユーザー登録画面（new画面）に行かせないように、コントローラで制御できているかテスト" do
      visit new_user_path

      expect(page).not_to have_content "アカウント登録画面"
    end

    scenario "自分（current_user）以外のユーザのマイページ（userのshow画面）に行かせないように、コントローラで制御できているかテスト" do
      visit user_path(@user2)

      expect(page).to have_content "test_user_01さんのマイページはこちらです。"
    end

    scenario "ログアウトできるかテスト" do
      click_on "ログアウト"

      expect(page).to have_content "ログアウトしました。"
    end
  end
end
