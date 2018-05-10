class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.includes(:images)
    respond_to do |format|
      format.json { render json: @products, only: :title, include: { category: { only: :name } } }
      format.html
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    build_images_for_product
  end

  # GET /products/1/edit
  def edit
    build_images_for_product
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_create_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        build_images_for_product
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_edit_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
        @products = Product.all
        ActionCable.server.broadcast 'products',
        html: render_to_string('store/index', layout: false)
      else
        build_images_for_product
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to products_url, notice: @product.errors.full_messages.join(', ') }
        format.json { head :no_content }
      end
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.atom
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_edit_params
      params.require(:product).permit(:title, :description, :image_url, :price, :enabled, :discount_price, :permalink, :category_id, images_attributes: [:id, :uploaded_image])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_create_params
      params.require(:product).permit(:title, :description, :image_url, :price, :enabled, :discount_price, :permalink, :category_id, images_attributes: [:uploaded_image])
    end

    def build_images_for_product
      (MAX_ALLOWED_IMAGES_FOR_A_PRODUCT + 1 - @product.images.length).times { @product.images.build }
    end
end
