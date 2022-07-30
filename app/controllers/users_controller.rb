class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if  @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app #{@user.name}"
      redirect_to user_path(@user) #or just redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end


  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to login_path, status: :see_other
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, status: :see_other unless @user == current_user
  end
end
