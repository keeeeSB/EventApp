require 'rails_helper'

RSpec.describe '新規登録', type: :system do
  describe 'ユーザー登録' do
    it 'エンドユーザーは新規登録を行うことができる' do
      visit root_path
      click_link '新規登録'
      expect(page).to have_current_path new_user_registration_path

      fill_in 'お名前', with: 'アリス'
      fill_in 'メールアドレス', with: 'alice@example.com'
      fill_in 'パスワード', with: 'password12345', match: :prefer_exact
      fill_in 'パスワード（確認用）', with: 'password12345'
      fill_in '自己紹介', with: 'よろしくお願いします。'

      expect {
        click_button '登録する'
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
        expect(page).to have_current_path root_path
      }.to change(User, :count).by(1)

      email = open_last_email

      expect(email.subject).to eq 'メールアドレス確認メール'

      click_first_link_in_email(email)

      expect(page).to have_content 'メールアドレスが確認できました。'
      expect(page).to have_current_path new_user_session_path
    end
  end
end
