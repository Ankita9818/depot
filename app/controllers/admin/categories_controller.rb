class Admin::CategoriesController < Admin::AdminBasicController
  before_action :get_category, only: :products

  def index
    @categories = Category.includes(:parent_category)
  end

  def products
    @products = @category.products
    @sub_products = @category.sub_products
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_category
      unless @category = Category.includes(:products, :sub_products).find_by_id(params[:id])
        respond_to do |format|
          format.html { redirect_to admin_categories_path, notice: "Invalid Category" }
        end
      end
    end
end
