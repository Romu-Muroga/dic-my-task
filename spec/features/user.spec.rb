require "rails_helper"

RSpec.feature "ユーザー管理機能", type: :feature do

  background do
    FactoryBot.create(:user)
    FactoryBot.create(:second_user)
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

  scenario "管理者権限を持たないユーザーがユーザー管理機能にアクセスできないようになっているかテスト" do
    visit root_path

    fill_in "メールアドレス", with: "test_user_02@dic.com"
    fill_in "パスワード", with: "password"

    within ".form_outer" do
      click_on "ログイン"
    end

    visit admin_users_path
    expect(page).to have_content "管理者権限がありません。"

    visit admin_labels_path
    expect(page).to have_content "管理者権限がありません。"
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

    scenario "管理者権限を持つユーザーがユーザー一覧画面へ遷移できるかテスト" do
      click_on "ユーザー一覧へ"

      expect(page).to have_content "test_user_01", "test_user_01@dic.com"
      expect(page).to have_content "test_user_02", "test_user_02@dic.com"
    end

    scenario "管理者権限を持つユーザーがユーザーを新規登録できるかテスト" do
      visit new_admin_user_path

      fill_in "氏名", with: "テストユーザー"
      fill_in "メールアドレス", with: "test_user@dic.com"
      uncheck "管理者権限"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"

      click_on "登録する"

      expect(page).to have_content "アカウント登録しました。"
      expect(page).to have_content "氏名", "テストユーザー"
      expect(page).to have_content "メールアドレス", "test_user@dic.com"
      expect(page).to have_content "管理者権限", "なし"
    end

    scenario "管理者権限を持つユーザーが任意のユーザー詳細画面に遷移できるかテスト" do
      click_on "ユーザー一覧へ"
      click_link "test_user_01"

      expect(page).to have_content "氏名", "test_user_01"
      expect(page).to have_content "メールアドレス", "test_user_01@dic.com"
      expect(page).to have_content "管理者権限", "あり"
    end

    scenario "管理者権限を持つユーザーが任意のユーザー情報を編集できるかテスト" do
      click_on "ユーザー一覧へ"

      all("tbody tr")[1].click_link "編集"

      fill_in "氏名", with: "氏名を変更する"
      fill_in "メールアドレス", with: "test_user@dic.com"
      uncheck "管理者権限"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"

      click_on "更新する"

      expect(page).to have_content "編集しました。"
      expect(page).to have_content "氏名", "氏名を変更する"
      expect(page).to have_content "メールアドレス", "test_user@dic.com"
      expect(page).to have_content "管理者権限", "なし"
    end

    scenario "管理者権限を持つユーザーが任意のユーザーを削除できるかテスト" do
      click_on "ユーザー一覧へ"

      all("tbody tr")[1].click_link "削除"

      expect(page).to have_content "ユーザー「test_user_02」を削除しました。"
    end

    scenario "ログアウトできるかテスト" do
      click_on "ログアウト"

      expect(page).to have_content "ログアウトしました。"
    end
  end
end
