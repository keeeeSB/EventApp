class Events::ReviewsController < Events::ApplicationController
  before_action :set_review, only: %i[edit update destroy]

  def new
    @review = current_user.reviews.build
  end

  def edit
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to event_path(@review.event), notice: 'レビューを投稿しました。'
    else
      flash.now[:alert] = 'レビューを投稿できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @review.update(review_params)
      redirect_to event_path(@review.event), notice: 'レビューを更新しました。'
    else
      flash.now[:alert] = 'レビューを更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @review.destroy!
    redirect_to event_path(@review.event), notice: 'レビューを削除しました。', status: :see_other
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.expect(review: %i[rating comment]).merge(event_id: params[:event_id])
  end
end
