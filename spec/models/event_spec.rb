require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:upcoming_event) { create(:event, :upcoming) }
  let(:past_event) { create(:event, :past) }

  describe '.upcoming' do
    it '開催予定のイベントのみを取得できること' do
      result = Event.upcoming

      expect(result).to eq [upcoming_event]
      expect(result).not_to eq [past_event]
    end
  end

  describe '.past' do
    it '開催済みのイベントのみを取得できること' do
      result = Event.past

      expect(result).to eq [past_event]
      expect(result).not_to eq [upcoming_event]
    end
  end
end
