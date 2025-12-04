class Admins::ReviewsController < Admins::ApplicationController
  before_action :set_review, only: %i[show destroy]

  def index
    @reviews = Review.default_order.page(params[:page])
  end

  def show
  end

  def destroy
    @review.destroy!
    redirect_to admins_reviews_path, notice: 'レビューを削除しました。', status: :see_other
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end
end
