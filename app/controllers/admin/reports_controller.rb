class Admin::ReportsController < Admin::AdminBasicController
  before_action :get_dates, only: :index

  def index
    @orders = Order.includes(:user).by_date(@from_date, @to_date)
  end

  private def get_dates
    if params[:from_date] && params[:from_date]
      @from_date = params[:from_date].to_date
      @to_date = params[:to_date].to_date
    else
      @from_date = Time.current.beginning_of_day - ORDER_TIME_PERIOD
      @to_date = Time.current.beginning_of_day
    end
  end
end
