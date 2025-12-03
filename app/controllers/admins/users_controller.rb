class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.default_order.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), notice: 'ユーザー情報を更新しました。'
    else
      flash.now[:alert] = 'ユーザー情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_path, notice: 'ユーザーを削除しました。', status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: %i[name introduction])
  end
end
