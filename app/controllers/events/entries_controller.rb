class Events::EntriesController < ApplicationController
  before_action :authenticate_user!

  def create
    @entry = current_user.entry.build(event_id: params[:id])
    if @entry.save
      redirect_to event_path(@entry.event), notice: 'イベントへ参加申し込みを行いました。'
    else
      redirect_to event_path(@entry.event), alert: '参加申し込みが出来ませんでした。'
    end
  end

  def destroy
    @entry = current_user.entry.find_by(event_id: params[:id])
    @entry.destroy!
    redirect_to event_path(@entry.event), notice: '参加申し込みを取り消しました。'
  end
end
