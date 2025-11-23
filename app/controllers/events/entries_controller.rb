class Events::EntriesController < Events::ApplicationController
  def create
    @entry = current_user.entries.build(event_id: params[:event_id])
    if @entry.save
      redirect_to event_path(@entry.event), notice: 'イベントへ参加申し込みを行いました。'
    else
      redirect_to event_path(@entry.event), alert: '参加申し込みが出来ませんでした。'
    end
  end

  def destroy
    @entry = current_user.entries.find_by(event_id: params[:event_id])
    @entry.destroy!
    redirect_to event_path(@entry.event), notice: '参加申し込みを取り消しました。'
  end
end
