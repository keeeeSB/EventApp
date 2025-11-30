class Events::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
