class Users::MyEventsController < Users::ApplicationController
  def index
    @events = current_user.entry_events.upcoming.order(started_at: :desc)
  end
end
