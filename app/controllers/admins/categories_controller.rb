class Admins::CategoriesController < Admins::ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.default_order.page(params[:page])
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admins_category_path(@category), notice: 'カテゴリーを作成しました。'
    else
      flash.now[:alert] = 'カテゴリーを作成できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admins_category_path(@category), notice: 'カテゴリーを更新しました。'
    else
      flash.now[:alert] = 'カテゴリーを更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy!
    redirect_to admins_categories_path, notice: 'カテゴリーを削除しました。', status: :see_other
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.expect(category: %i[name])
  end
end
