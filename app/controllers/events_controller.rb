class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def upcoming
    @events = Event.upcoming.popular.page(params[:page])
  end

  def past
    @events = Event.past.order(started_at: :desc, id: :desc).page(params[:page])
  end
end
