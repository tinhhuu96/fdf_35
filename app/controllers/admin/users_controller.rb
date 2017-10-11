class Admin::UsersController < ApplicationController
  before_action :admin_user, only: :destroy
  before_action :load_user, only: :show

  def show; end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "users_controller.signup"
      redirect_to root_url
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :address, :password,
      :password_confirmation)
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users_controller.errorss"
    redirect_to users_path
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end