class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def upcoming
    @events = Event.upcoming.popular_order.page(params[:page])
  end

  def past
    @events = Event.past.with_review_stats.order(started_at: :desc, id: :desc).page(params[:page])
  end
end
