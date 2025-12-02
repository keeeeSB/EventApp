require 'rails_helper'

RSpec.describe 'イベント管理機能', type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user, name: 'アリス') }
  let(:category) { create(:category, name: '学習') }
  let!(:event) do
    create(:event,
           title: 'Ruby勉強会',
           description: 'みんなで勉強しましょう！',
           started_at: '002030-01-01T12:00',
           venue: '各家庭',
           user:,
           category:)
  end

  describe 'イベントの一覧' do
    it '管理者は、イベントの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'イベント一覧'
      expect(page).to have_current_path admins_events_path

      expect(page).to have_selector 'h2', text: 'イベント一覧'

      within('tr', text: 'Ruby勉強会') do
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content 'アリス'
        expect(page).to have_content '学習'
        expect(page).to have_content '未開催'
      end
    end
  end

  describe 'イベントの詳細' do
    it '管理者は、イベントの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_events_path

      within('tr', text: 'Ruby勉強会') do
        expect(page).to have_content 'Ruby勉強会'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_event_path(event)

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content 'みんなで勉強しましょう！'
      expect(page).to have_content '2030年1月1日 12:00'
      expect(page).to have_content '各家庭'
      expect(page).to have_content 'アリス'
      expect(page).to have_content '学習'
      expect(page).to have_content '未開催'
    end
  end

  describe 'イベントの編集' do
    before do
      create(:category, name: '趣味')
    end

    it '管理者は、イベント情報を編集できる' do
      login_as admin, scope: :admin
      visit admins_events_path

      expect(page).to have_selector 'h2', text: 'イベント一覧'

      within('tr', text: 'Ruby勉強会') do
        expect(page).to have_content 'Ruby勉強会'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content 'みんなで勉強しましょう！'
      expect(page).to have_content '2030年1月1日 12:00'
      expect(page).to have_content '各家庭'
      expect(page).to have_content 'アリス'
      expect(page).to have_content '学習'
      expect(page).to have_content '未開催'

      click_link '編集する'

      expect(page).to have_current_path edit_admins_event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント編集'

      fill_in 'タイトル', with: 'Java勉強会'
      fill_in '説明', with: '勉強しよう！'
      fill_in '開催日時', with: '002020-01-01T12:00'
      fill_in '開催場所', with: '各家庭'
      select '趣味', from: 'カテゴリー'
      click_button '更新する'

      expect(page).to have_content 'イベント情報を更新しました。'
      expect(page).to have_current_path admins_event_path(event)

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Java勉強会'
      expect(page).to have_content '勉強しよう！'
      expect(page).to have_content '2020年1月1日 12:00'
      expect(page).to have_content '各家庭'
      expect(page).to have_content 'アリス'
      expect(page).to have_content '趣味'
      expect(page).to have_content '開催済み'
    end
  end

  describe 'イベントの削除' do
    it '管理者は、イベントを削除できる' do
      login_as admin, scope: :admin
      visit admins_events_path

      expect(page).to have_selector 'h2', text: 'イベント一覧'

      within('tr', text: 'Ruby勉強会') do
        expect(page).to have_content 'Ruby勉強会'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'イベントを削除しました。'
        expect(page).to have_current_path admins_events_path
      }.to change(Event, :count).by(-1)

      expect(page).to have_selector 'h2', text: 'イベント一覧'
      expect(page).not_to have_content 'Ruby勉強会'
    end
  end
end
