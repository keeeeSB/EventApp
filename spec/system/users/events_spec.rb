require 'rails_helper'

RSpec.describe 'イベント機能', type: :system do
  let(:user) { create(:user, name: 'アリス') }
  let!(:category) { create(:category, name: 'プログラミング') }

  describe 'イベント作成' do
    it 'ログイン中のユーザーは、イベントを作成できる' do
      login_as user, scope: :user
      visit root_path

      click_link 'イベント作成'
      expect(page).to have_current_path new_users_event_path

      expect(page).to have_selector 'h2', text: 'イベント作成'
      fill_in 'タイトル', with: 'Ruby勉強会'
      fill_in '説明', with: '勉強会を開催します！'
      fill_in '開催日時', with: '002030-01-01T12:00'
      fill_in '開催場所', with: '各家庭'
      select 'プログラミング', from: 'カテゴリー'

      expect {
        click_button '登録する'
        expect(page).to have_content 'イベントを作成しました。'
      }.to change(Event, :count).by(1)

      event = Event.last

      expect(page).to have_current_path event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '勉強会を開催します！'
      expect(page).to have_content '作成者： アリス'
      expect(page).to have_content '開催日時： 2030年1月1日 12:00'
      expect(page).to have_content '開催場所： 各家庭'
      expect(page).to have_content 'プログラミング'
    end
  end

  describe 'イベント編集' do
    let!(:event) do
      create(
        :event,
        title: 'Ruby勉強会',
        description: '勉強会を開催します。',
        started_at: '002030-01-01T12:00',
        venue: '各家庭',
        category:,
        user:
      )
    end

    it 'ログイン中のユーザーは、自身が作成したイベントを編集できる' do
      login_as user, scope: :user
      visit root_path

      within first('.card') do
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'
        expect(page).to have_content '開催場所： 各家庭'

        click_link '編集'
      end

      expect(page).to have_current_path edit_users_event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント編集'
      fill_in 'タイトル', with: 'Java勉強会'
      fill_in '説明', with: 'Javaの勉強会を開催します！'
      fill_in '開催日時', with: '002030-02-01T12:00'
      fill_in '開催場所', with: '公民館'
      select 'プログラミング', from: 'カテゴリー'
      click_button '更新する'

      expect(page).to have_current_path event_path(event)
      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Java勉強会'
      expect(page).to have_content 'Javaの勉強会を開催します！'
      expect(page).to have_content '作成者： アリス'
      expect(page).to have_content '開催日時： 2030年2月1日 12:00'
      expect(page).to have_content '開催場所： 公民館'
      expect(page).to have_content 'プログラミング'
    end
  end

  describe 'イベント削除' do
    let!(:event) do
      create(
        :event,
        title: 'Ruby勉強会',
        description: '勉強会を開催します！',
        started_at: '002030-01-01T12:00',
        venue: '各家庭',
        category:,
        user:
      )
    end

    it 'ログイン中のユーザーは、自身が作成したイベントを削除できる' do
      login_as user, scope: :user
      visit root_path

      expect(page).to have_selector 'h2', text: '未開催イベント一覧'
      within first('.card') do
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します！'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'
        expect(page).to have_content '開催場所： 各家庭'
        expect(page).to have_content 'プログラミング'
      end

      visit event_path(event)

      expect {
        accept_confirm do
          click_button '削除'
        end
        expect(page).to have_content 'イベントを削除しました。'
        expect(page).to have_current_path root_path
      }.to change(Event, :count).by(-1)

      expect(page).not_to have_content 'Ruby勉強会'
      expect(page).not_to have_content '勉強会を開催します。'
    end
  end
end
