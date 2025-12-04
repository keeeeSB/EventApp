class Admins::Events::ReviewsController < Admins::ApplicationController
  before_action :set_event
  before_action :set_review, only: %i[show destroy]

  def index
    @reviews = @event.reviews.default_order.page(params[:page])
  end

  def show
  end

  def destroy
    @review.destroy!
    redirect_to admins_event_reviews_path(@event), notice: 'レビューを削除しました。', status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_review
    @review = @event.reviews.find(params[:id])
  end
end
