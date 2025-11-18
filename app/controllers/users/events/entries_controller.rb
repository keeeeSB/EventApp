class Users::Events::EntriesController < Users::ApplicationController
  def index
    @entries = @event.entries.default_order
  end

  def update
    @entry = @event.entries.find(params[:id])
    if @entry.update(status: params[:status])
      redirect_to users_event_entries_path(@event), notice: '申し込み情報を更新しました。'
    else
      redirect_to users_event_entries_path(@event), alert: '申し込み情報を更新できませんでした。'
    end
  end

  private

  def set_event
    @event = current_user.events.find(params[:event_id])
  end
end
