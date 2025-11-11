require 'rails_helper'

RSpec.describe 'カテゴリー機能', type: :system do
  let(:admin) { create(:admin) }

  describe 'カテゴリー一覧' do
    before do
      create(:category, name: 'スポーツ')
    end

    it '管理者は、カテゴリー一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'カテゴリー一覧'
      expect(page).to have_selector 'h2', text: 'カテゴリー一覧'
      expect(page).to have_current_path admins_categories_path

      expect(page).to have_content 'スポーツ'
    end
  end

  describe 'カテゴリー詳細' do
    let!(:category) { create(:category, name: 'スポーツ') }

    it '管理者は、カテゴリーの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_categories_path

      expect(page).to have_selector 'h2', text: 'カテゴリー一覧'
      expect(page).to have_content 'スポーツ'

      within('tr', text: 'スポーツ') do
        click_link '詳細'
      end

      expect(page).to have_content 'カテゴリー詳細'
      expect(page).to have_current_path admins_category_path(category)

      expect(page).to have_content 'スポーツ'
    end
  end

  describe 'カテゴリー作成' do
    it '管理者は、カテゴリーを作成できる' do
      login_as admin, scope: :admin
      visit admins_categories_path

      click_link 'カテゴリーを追加'
      expect(page).to have_current_path new_admins_category_path
      expect(page).to have_selector 'h2', text: 'カテゴリー作成'

      fill_in 'カテゴリー名', with: 'スポーツ'
      expect {
        click_button '登録する'
        expect(page).to have_content 'カテゴリーを作成しました。'
      }.to change(Category, :count).by(1)

      category = Category.last

      expect(page).to have_current_path admins_category_path(category)
      expect(page).to have_content 'スポーツ'
    end
  end

  describe 'カテゴリー編集' do
    let!(:category) { create(:category, name: 'スポーツ') }

    it '管理者は、既存のカテゴリーを編集できる' do
      login_as admin, scope: :admin
      visit admins_categories_path

      expect(page).to have_content 'スポーツ'

      within('tr', text: 'スポーツ') do
        click_link '編集'
      end

      expect(page).to have_selector 'h2', text: 'カテゴリー編集'
      expect(page).to have_current_path edit_admins_category_path(category)

      fill_in 'カテゴリー名', with: '趣味'
      click_button '更新する'

      expect(page).to have_content 'カテゴリーを更新しました。'
      expect(page).to have_current_path admins_category_path(category)

      expect(page).to have_content '趣味'
    end
  end

  describe 'カテゴリー削除' do
    before do
      create(:category, name: 'スポーツ')
    end

    it '管理者は、既存のカテゴリーを削除できる' do
      login_as admin, scope: :admin
      visit admins_categories_path

      expect(page).to have_content 'スポーツ'

      within('tr', text: 'スポーツ') do
        accept_confirm do
          click_button '削除'
        end
      end

      expect(page).to have_content 'カテゴリーを削除しました。'
      expect(page).to have_current_path admins_categories_path

      expect(page).to have_selector 'h2', text: 'カテゴリー一覧'
      expect(page).not_to have_content 'スポーツ'
    end
  end
end
