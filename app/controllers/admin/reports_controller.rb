class Admin::ReportsController < Admin::AdminBasicController
  before_action :get_dates
  def index
    @orders = Order.where( created_at: @from_date..@to_date )
  end

  private
  def reports_params
    params.permit(report: [:from_date, :to_date])
  end

  def get_dates
    unless params[:report] && (@from_date = params[:report][:from_date].to_date) && (@to_date = params[:report][:to_date].to_date)
      @from_date = Time.current.beginning_of_day - 5.days
      @to_date = Time.current.beginning_of_day
    end
  end
end
