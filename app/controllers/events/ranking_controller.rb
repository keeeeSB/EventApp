class Events::RankingController < Events::ApplicationController
  skip_before_action :set_event

  def index
    if params[:slug].present?
      category = Category.find_by!(name: params[:slug])
      @events = Event.where(category:).with_review_stats.order(average_rating: :desc)
    else
      @events = Event.with_review_stats.order(average_rating: :desc)
    end
  end
end
