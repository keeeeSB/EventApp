class Users::EventsController < Users::ApplicationController
  before_action :set_event, only: %i[edit update destroy]

  def new
    @event = current_user.events.build
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to event_path(@event), notice: 'イベントを作成しました。'
    else
      flash.now[:alert] = 'イベントを作成できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: 'イベント情報を更新しました。'
    else
      flash.now[:alert] = 'イベント情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy!
    redirect_to
  end

  private

  def event_params
    params.expect(event: %i[title description started_at venue category_id])
  end

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
