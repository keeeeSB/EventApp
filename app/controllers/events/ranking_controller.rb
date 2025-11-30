class Events::RankingController < Events::ApplicationController
  skip_before_action :set_event

  def index
    if params[:slug].present?
      category = Category.find_by!(name: params[:slug])
      @events = Event.where(category:).with_review_stats.order('average_rating DESC')
    else
      @events = Event.with_review_stats.order('average_rating DESC')
    end
  end
end
