class Admin::AdminBasicController < ApplicationController
  before_action :ensure_admin

  protected

    def ensure_admin
      unless current_user.admin?
        redirect_to store_index_path, notice: t('.unauthorized')
      end
    end
end
