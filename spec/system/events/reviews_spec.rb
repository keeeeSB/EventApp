require 'rails_helper'

RSpec.describe 'レビュー機能', type: :system do
  let(:alice) { create(:user, name: 'アリス') }
  let(:past_event) { create(:event, title: 'Ruby勉強会', started_at: '002000-01-01T12:00', user: alice) }

  describe 'レビュー投稿' do
    context '開催済みのイベントの場合' do
      it 'ログイン中のユーザーは、レビューを投稿できる' do
        login_as alice, scope: :user
        visit event_path(past_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '開催日時： 2000年1月1日 12:00'
        expect(page).to have_link 'レビューを投稿する'

        click_link 'レビューを投稿する'

        expect(page).to have_current_path new_event_review_path(past_event)
        expect(page).to have_selector 'h2', text: 'レビュー投稿'

        select 5, from: '評価'
        fill_in 'コメント', with: 'とてもいいイベントでした。'

        expect {
          click_button '投稿する'
          expect(page).to have_content 'レビューを投稿しました。'
          expect(page).to have_current_path event_path(past_event)
        }.to change(past_event.reviews, :count).by(1)

        within('[data-test-class="review-card"]') do
          expect(page).to have_content 'アリス'
          expect(page).to have_css '.bi-star-fill', count: 5
          expect(page).to have_content 'とてもいいイベントでした。'
        end
      end

      it 'レビュー済みなら、レビュー投稿リンクは表示されない' do
        create(:review, rating: 5, comment: 'とてもいいイベントでした。', user: alice, event: past_event)

        login_as alice, scope: :user
        visit event_path(past_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content 'Ruby勉強会'
        expect(page).to have_content '開催日時： 2000年1月1日 12:00'
        expect(page).not_to have_link 'レビューを投稿する'

        expect(page).to have_content '既にレビューを投稿済みです。'

        within('[data-test-class="review-card"]') do
          expect(page).to have_content 'アリス'
          expect(page).to have_css '.bi-star-fill', count: 5
          expect(page).to have_content 'とてもいいイベントでした。'
        end
      end
    end

    context '未開催のイベントの場合' do
      let(:upcoming_event) { create(:event, title: '野球鑑賞会', started_at: '002030-01-01T12:00', user: alice) }

      it 'ユーザーはレビュー投稿リンクは表示されない' do
        visit event_path(upcoming_event)

        expect(page).to have_selector 'h2', text: 'イベント詳細'
        expect(page).to have_content '野球鑑賞会'
        expect(page).to have_content '開催日時： 2030年1月1日 12:00'
        expect(page).not_to have_link 'レビューを投稿する'
      end
    end
  end

  describe 'レビュー編集' do
    it 'ログイン中のユーザーは、自身が投稿したレビューを編集できる' do
      create(:review, rating: 3, comment: 'とてもいいイベントでした。', user: alice, event: past_event)

      login_as alice, scope: :user
      visit event_path(past_event)

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '開催日時： 2000年1月1日 12:00'
      expect(page).not_to have_link 'レビューを投稿する'

      within('[data-test-class="review-card"]') do
        expect(page).to have_content 'アリス'
        expect(page).to have_content 'とてもいいイベントでした。'
        expect(page).to have_link '編集'

        click_link '編集'
      end

      expect(page).to have_current_path edit_event_review_path(past_event)
      expect(page).to have_selector 'h2', text: 'レビュー編集'

      select '5', from: '評価'
      fill_in 'コメント', with: 'とてもいいイベントでした。'
      click_button '投稿する'

      expect(page).to have_content 'レビューを更新しました。'
      expect(page).to have_current_path event_path(past_event)

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '開催日時： 2000年1月1日 12:00'

      within('[data-test-class="review-card"]') do
        expect(page).to have_content 'アリス'
        expect(page).to have_css '.bi-star-fill', count: 5
        expect(page).to have_content 'とてもいいイベントでした。'
        expect(page).to have_link '編集'
      end
    end
  end

  describe 'レビュー削除' do
    it 'ログイン中のユーザーは、自身が投稿したレビューを削除できる' do
      create(:review, rating: 3, comment: 'とてもいいイベントでした。', user: alice, event: past_event)

      login_as alice, scope: :user
      visit event_path(past_event)

      expect(page).to have_selector 'h2', text: 'イベント詳細'
      expect(page).to have_content 'Ruby勉強会'
      expect(page).to have_content '開催日時： 2000年1月1日 12:00'
      expect(page).not_to have_link 'レビューを投稿する'

      within('[data-test-class="review-card"]') do
        expect(page).to have_content 'アリス'
        expect(page).to have_content 'とてもいいイベントでした。'

        accept_confirm do
          click_button '削除'
        end
      end

      expect(page).to have_content 'レビューを削除しました。'
      expect(page).to have_current_path event_path(past_event)

      expect(page).not_to have_css '.bi-star-fill', count: 5
      expect(page).not_to have_content 'とてもいいイベントでした。'
    end
  end
end
