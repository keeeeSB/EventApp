require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  let(:admin) { create(:admin) }
  let!(:user) do
    create(:user,
           name: 'アリス',
           email: 'alice@example.com',
           introduction: 'よろしくお願いします。',
           confirmed_at: Time.current)
  end

  describe 'ユーザー一覧' do
    it '管理者は、ユーザーの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'ユーザー一覧'
      expect(page).to have_current_path admins_users_path

      expect(page).to have_selector 'h2', text: 'ユーザー一覧'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content '承認済み'
    end
  end

  describe 'ユーザー詳細' do
    it '管理者は、ユーザーの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_users_path

      expect(page).to have_selector 'h2', text: 'ユーザー一覧'

      within('tr', text: 'アリス') do
        expect(page).to have_content 'アリス'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_user_path(user)
      expect(page).to have_selector 'h2', text: 'ユーザー詳細'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content 'よろしくお願いします。'
      expect(page).to have_content '承認済み'
    end
  end

  describe 'ユーザー編集' do
    it '管理者は、ユーザー情報を編集できる' do
      login_as admin, scope: :admin
      visit admins_user_path(user)

      expect(page).to have_selector 'h2', text: 'ユーザー詳細'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content 'よろしくお願いします。'
      expect(page).to have_content '承認済み'

      click_link '編集する'
      expect(page).to have_current_path edit_admins_user_path(user)

      fill_in 'お名前', with: 'アーリス'
      fill_in '自己紹介', with: 'よろしく。'
      click_button '更新する'

      expect(page).to have_content 'ユーザー情報を更新しました。'
      expect(page).to have_current_path admins_user_path(user)

      expect(page).to have_content 'アーリス'
      expect(page).to have_content 'よろしく。'
    end
  end

  describe 'ユーザー削除' do
    it '管理者は、ユーザーを削除できる' do
      login_as admin, scope: :admin
      visit admins_user_path(user)

      expect(page).to have_selector 'h2', text: 'ユーザー詳細'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content 'よろしくお願いします。'
      expect(page).to have_content '承認済み'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'ユーザーを削除しました。'
        expect(page).to have_current_path admins_users_path
      }.to change(User, :count).by(-1)

      expect(page).not_to have_content 'アリス'
    end
  end
end
