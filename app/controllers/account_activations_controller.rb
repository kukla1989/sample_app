class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Congratulation! account activated."
      redirect_to user
    else
      flash[:danger] = "Activation link is invalid, try sign up again"
      redirect_to signup_path
    end
  end
end
