require 'rails_helper'

RSpec.describe 'レビュー管理機能', type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user, name: 'アリス') }
  let(:event) { create(:event, title: 'Ruby勉強会') }
  let!(:review) { create(:review, event:, user:, rating: 5, comment: 'とても良かったです。') }

  describe 'レビュー一覧' do
    it '管理者は、レビューの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'レビュー一覧'
      expect(page).to have_current_path admins_reviews_path

      expect(page).to have_selector 'h2', text: 'レビュー一覧'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '5'
    end
  end

  describe 'レビュー詳細' do
    it '管理者は、レビューの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_reviews_path

      expect(page).to have_selector 'h2', text: 'レビュー一覧'

      within('tr', text: 'Ruby勉強会') do
        expect(page).to have_content 'Ruby勉強会'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_review_path(review)
      expect(page).to have_selector 'h2', text: 'レビュー詳細'
      expect(page).to have_content 'アリス'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '5'
      expect(page).to have_content 'とても良かったです。'
    end
  end

  describe 'レビュー削除' do
    it '管理者は、レビューを削除できる' do
      login_as admin, scope: :admin
      visit admins_review_path(review)

      expect(page).to have_selector 'h2', text: 'レビュー詳細'

      expect(page).to have_content 'アリス'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content 'とても良かったです。'

      expect do
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'レビューを削除しました。'
        expect(page).to have_current_path admins_reviews_path
      end.to change(Review, :count).by(-1)

      expect(page).to have_selector 'h2', text: 'レビュー一覧'
      expect(page).not_to have_content 'Ruby勉強会'
      expect(page).not_to have_content 'アリス'
    end
  end
end
