class SessionsController < ApplicationController
  skip_before_action :authorize, :logout_user_on_inactivity
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:recent_activity_log] = Time.now
      if user.role == "admin"
        redirect_to admin_reports_url
      else
        redirect_to admin_url
      end
    else
      redirect_to login_url, alert: 'Invalid username/password combination.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: 'Logged out'
  end
end
