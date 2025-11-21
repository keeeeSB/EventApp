require 'rails_helper'

RSpec.describe '参加状況管理機能', type: :system do
  describe '参加状況管理' do
    let(:alice) { create(:user, name: 'アリス') }
    let(:bob) { create(:user, name: 'ボブ') }

    context '未開催イベントの場合' do
      let(:event) { create(:event, title: 'Ruby勉強会', description: '勉強会を開催します。', user: alice, started_at: '002030-01-01T12:00') }

      it 'ログイン中のユーザーが、イベントの作成者の場合、参加者の参加状況を変更できる' do
        create(:entry, user: bob, event:, status: :pending)

        login_as alice, scope: :user
        visit event_path(event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '作成者： アリス'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'
        expect(page).to have_link '参加者一覧へ'

        click_link '参加者一覧へ'
        expect(page).to have_current_path users_event_entries_path(event)

        expect(page).to have_selector 'h2', text: '参加申し込み一覧'

        within first('tbody tr') do
          expect(page).to have_content 'ボブ'
          expect(page).to have_content '申し込み中'
          expect(page).to have_button '参加を許可'
          expect(page).to have_button '参加を却下'
          click_button '参加を許可'
        end

        expect(page).to have_content '申し込み情報を更新しました。'
        expect(page).to have_current_path users_event_entries_path(event)

        within first('tbody tr') do
          expect(page).to have_content 'ボブ'
          expect(page).to have_content '参加'
          expect(page).to have_button '参加を却下'
          expect(page).not_to have_button '参加を許可'
        end
      end

      it 'ログイン中のユーザーが、イベントの作成者ではない場合、参加者の参加状況を変更できない' do
        login_as bob, scope: :user
        visit event_path(event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '作成者： アリス'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'
        expect(page).not_to have_link '参加者一覧へ'
      end
    end

    context '開催済みイベントの場合' do
      let(:event) { create(:event, title: 'Ruby勉強会', description: '勉強会を開催します。', user: alice, started_at: '002020-01-01T12:00') }

      it 'ログイン中のユーザーが、イベントの作成者でも、参加者の参加状況を変更できない' do
        create(:entry, user: bob, event:, status: :accepted)

        login_as alice, scope: :user
        visit event_path(event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '勉強会を開催します。'
        expect(page).to have_content '作成者： アリス'
        expect(page).to have_content '開催日時： 2020年1月1日 12:00'
        expect(page).to have_link '参加者一覧へ'

        click_link '参加者一覧へ'
        expect(page).to have_current_path users_event_entries_path(event)

        expect(page).to have_selector 'h2', text: '参加申し込み一覧'

        within first('tbody tr') do
          expect(page).to have_content 'ボブ'
          expect(page).to have_content '参加'
          expect(page).not_to have_button '参加を却下'
        end
      end
    end
  end
end
