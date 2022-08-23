class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if  @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end 

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url unless @user.activated?
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user was destroyed"
    redirect_to users_path, status: :see_other
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, status: :see_other unless @user == current_user
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
