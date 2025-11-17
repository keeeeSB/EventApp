require 'rails_helper'

RSpec.describe 'イベント機能', type: :system do
  describe 'イベント一覧' do
    context '未開催の場合' do
      before do
        create(:event, :upcoming, title: 'Ruby勉強会', description: '勉強会を開催します！')
      end

      it 'ユーザーは、未開催のイベントの一覧を閲覧できる' do
        visit root_path
        click_link '未開催イベント'
        expect(page).to have_current_path upcoming_events_path

        expect(page).to have_selector 'h2', text: '未開催イベント一覧'
        within first('.card') do
          expect(page).to have_content 'Ruby勉強会'
          expect(page).to have_content '勉強会を開催します！'
        end
      end
    end

    context '開催済みの場合' do
      before do
        create(:event, :past, title: 'スポーツ大会', description: 'みんなでスポーツをしよう！')
      end

      it 'ユーザーは、開催済みのイベントの一覧を閲覧できる' do
        visit root_path
        click_link '開催済みイベント'
        expect(page).to have_current_path past_events_path

        expect(page).to have_selector 'h2', text: '開催済みイベント一覧'
        within('.card') do
          expect(page).to have_content 'スポーツ大会'
          expect(page).to have_content 'みんなでスポーツをしよう！'
        end
      end
    end
  end

  describe 'イベント詳細' do
    let(:user) { create(:user, name: 'アリス') }
    let(:category) { create(:category, name: 'プログラミング') }
    let!(:event) do
      create(
        :event,
        title: 'Ruby勉強会',
        description: '勉強会を開催します！',
        started_at: '002030-01-01T12:00',
        venue: '各家庭',
        user:,
        category:
      )
    end

    it 'ユーザーは、イベントの詳細を閲覧できる' do
      visit root_path

      within first('.card') do
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します！'

        click_link 'Ruby勉強会'
      end

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_current_path event_path(event)
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '勉強会を開催します！'
      expect(page).to have_content '作成者： アリス'
      expect(page).to have_content '開催日時： 2030年1月1日 12:00'
      expect(page).to have_content '開催場所： 各家庭'
      expect(page).to have_content 'プログラミング'
    end
  end
end
