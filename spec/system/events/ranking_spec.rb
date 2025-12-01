require 'rails_helper'

RSpec.describe 'ランキング機能', type: :system do
  describe 'イベントランキング表示' do
    let(:user) { create(:user) }
    let!(:sports) { create(:category, name: 'スポーツ') }
    let!(:study) { create(:category, name: '勉強') }
    let!(:hobby) { create(:category, name: '趣味') }

    before do
      create(:event, :past, title: 'Ruby勉強会', category: study) do |event|
        create_list(:review, 3, event:, rating: 5)
      end
      create(:event, :past, title: '野球鑑賞会', category: sports) do |event|
        create(:review, event:, rating: 5)
        create(:review, event:, rating: 3)
      end
      create(:event, :past, title: 'コーヒーで一息', category: hobby) do |event|
        create(:review, event:, rating: 3)
      end
    end

    context 'ログイン中のユーザーの場合' do
      it '全体の平均レビュー順イベントランキングを閲覧できる' do
        login_as user, scope: :user
        visit root_path

        click_link 'イベントランキング'
        expect(page).to have_current_path events_ranking_index_path

        expect(page).to have_selector 'h2', text: 'イベントランキング'

        cards = all('.card')

        within cards[0] do
          expect(page).to have_content 'Ruby勉強会'
          expect(page).to have_content '平均レビュー: 5.0 (3件)'
        end

        within cards[1] do
          expect(page).to have_content '野球鑑賞会'
          expect(page).to have_content '平均レビュー: 4.0 (2件)'
        end

        within cards[2] do
          expect(page).to have_content 'コーヒーで一息'
          expect(page).to have_content '平均レビュー: 3.0 (1件)'
        end
      end

      it 'カテゴリー別の平均レビュー順イベントランキングを閲覧できる' do
        login_as user, scope: :user
        visit events_ranking_index_path

        expect(page).to have_selector 'h2', text: 'イベントランキング'

        cards = all('.card')

        within cards[0] do
          expect(page).to have_content 'Ruby勉強会'
          expect(page).to have_content '勉強'
          expect(page).to have_content '平均レビュー: 5.0 (3件)'
        end

        within cards[1] do
          expect(page).to have_content '野球鑑賞会'
          expect(page).to have_content 'スポーツ'
          expect(page).to have_content '平均レビュー: 4.0 (2件)'
        end

        within cards[2] do
          expect(page).to have_content 'コーヒーで一息'
          expect(page).to have_content '趣味'
          expect(page).to have_content '平均レビュー: 3.0 (1件)'
        end

        click_link '趣味'
        expect(page).to have_current_path events_ranking_index_path(slug: '趣味')

        within first('.card') do
          expect(page).to have_content 'コーヒーで一息'
          expect(page).to have_content '趣味'
          expect(page).to have_content '平均レビュー: 3.0 (1件)'
        end

        expect(page).not_to have_content 'Ruby勉強会'
        expect(page).not_to have_content '野球鑑賞会'
      end
    end

    context 'ログインしていないユーザーの場合' do
      it '平均レビュー順イベントランキングを閲覧できない' do
        visit root_path

        expect(page).to have_selector 'h2', text: '未開催イベント一覧'
        expect(page).to have_link '未開催イベント'
        expect(page).to have_link '開催済みイベント'
        expect(page).not_to have_link 'イベントランキング'
      end
    end
  end
end
