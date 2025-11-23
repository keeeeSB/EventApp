require 'rails_helper'

RSpec.describe '参加申し込み機能', type: :system do
  let(:alice) { create(:user, name: 'アリス') }
  let(:bob) { create(:user, name: 'ボブ') }

  describe 'イベント参加申し込み' do
    context '開催前のイベントの場合' do
      let(:upcoming_event) { create(:event, title: 'Ruby勉強会', description: '勉強会を開催します。', user: bob, started_at: '002030-01-01T12:00') }

      it 'ログイン中のユーザーは、他のユーザーが作成したイベントに参加申し込みができる' do
        login_as alice, scope: :user
        visit event_path(upcoming_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '作成者： ボブ'
        expect(page).to have_button '参加申し込み'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'

        expect {
          click_button '参加申し込み'
          expect(page).to have_content 'イベントへ参加申し込みを行いました。'
          expect(page).to have_current_path event_path(upcoming_event)
        }.to change(upcoming_event.entries, :count).by(1)

        expect(page).to have_button '参加申し込み中'
        expect(page).not_to have_button '参加申し込み', exact: true
      end

      it 'ログイン中のユーザーは、参加申し込みを取り消すことができる' do
        create(:entry, user: alice, event: upcoming_event, status: :pending)

        login_as alice, scope: :user
        visit event_path(upcoming_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '作成者： ボブ'
        expect(page).to have_button '参加申し込み中'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'

        expect {
          click_button '参加申し込み中'
          expect(page).to have_content '参加申し込みを取り消しました。'
          expect(page).to have_current_path event_path(upcoming_event)
        }.to change(upcoming_event.entries, :count).by(-1)

        expect(page).to have_button '参加申し込み'
        expect(page).not_to have_button '参加申し込み中'
      end
    end

    context '開催後のイベントの場合' do
      let(:past_event) { create(:event, title: 'スポーツ鑑賞会', description: 'みんなでスポーツを観ましょう。。', user: bob, started_at: '002020-01-01T12:00') }

      it '参加申し込みボタンが表示されない' do
        login_as alice, scope: :user
        visit event_path(past_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'スポーツ鑑賞会'
        expect(page).to have_content 'みんなでスポーツを観ましょう。'
        expect(page).to have_content '作成者： ボブ'
        expect(page).to have_content '開催日時： 2020年1月1日 12:00'

        expect(page).not_to have_button '参加申し込み'
        expect(page).not_to have_button '参加取り消し'
      end
    end
  end
end
