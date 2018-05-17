class SessionsController < ApplicationController
  skip_before_action :authorize, :logout_user_on_inactivity
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:recent_activity_log] = Time.current
      after_sign_in_path(user)
    else
      redirect_to login_path, alert: 'Invalid username/password combination.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_path, notice: 'Logged out'
  end

  private def after_sign_in_path(user)
    if user.admin?
      redirect_to admin_reports_path
    else
      redirect_to admin_path
    end
  end

end
