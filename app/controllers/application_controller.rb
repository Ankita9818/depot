class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :set_i18n_locale_from_params
  before_action :set_hit_counter
  before_action :logout_user_on_inactivity
  around_action :set_custom_header
  helper_method :current_user

  protected

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: 'Please login'
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def current_user
    @logged_in_user ||= User.find_by_id(session[:user_id])
  end

  def set_custom_header
    pre_execution_time = Time.current
    yield
    post_execution_time = Time.current
    response.set_header('x-responded-in', (post_execution_time - pre_execution_time))
  end

  def set_hit_counter
    if cookies.key?(request.url)
      cookies[request.url] = cookies[request.url].to_i + 1
    else
      cookies[request.url] = 1
    end
  end

  def logout_user_on_inactivity
    if current_user
      if Time.now - session[:recent_activity_log].to_time > MAX_INACTIVE_PERIOD
        reset_session
        redirect_to root_path, notice: "Logged out due to inactivity"
      else
        session[:recent_activity_log] = Time.now
      end
    end
  end

  def record_not_found
    redirect_to root_path, notice: 'Invalid Request'
  end
end
