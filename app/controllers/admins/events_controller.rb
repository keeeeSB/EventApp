class Admins::EventsController < Admins::ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.default_order.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to admins_event_path(@event), notice: 'イベント情報を更新しました。'
    else
      flash.now[:alert] = 'イベント情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy!
    redirect_to admins_events_path, notice: 'イベントを削除しました。', status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.expect(event: %i[title description started_at venue category_id])
  end
end
