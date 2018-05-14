class Admin::AdminBasicController < ApplicationController
  before_action :ensure_admin

  protected

  def ensure_admin
    unless admin?
      redirect_to store_index_url, notice: 'You do not have privilege to access this section'
    end
  end
end
