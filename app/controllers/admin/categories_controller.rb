class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:show_products]

  def index
    @categories = Category.includes(:products)
  end

  def show_products
    @products = @category.products
    @sub_products = @category.sub_products
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      unless @category = Category.find_by_id(params[:id])
        respond_to do |format|
          format.html { redirect_to categories_url, notice: "Invalid Category" }
        end
      end
    end
end
