class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :delete_uploaded_images, only: [:destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
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
    @product.images.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        upload if params[:product][:images_attributes].present?
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      update_uploaded_images
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
        @products = Product.all
        ActionCable.server.broadcast 'products',
        html: render_to_string('store/index', layout: false)
      else
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


  def upload
    ["0", "1", "2"] .each do |i|
      uploaded_io = params[:product][:images_attributes][i]
      uploaded_io.each do |key, value|
        value.each do |file|
          path_to_file = Rails.root.join('public', 'uploads', file.instance_variable_get("@original_filename"))
          File.open(path_to_file, 'wb') do |uploaded_file|
            @product.images << Image.new(url: path_to_file)
            uploaded_file.write(file.read)
          end if max_allowed_images?
        end if value.respond_to? :each
      end if uploaded_io.respond_to? :each
    end
  end

  def delete_uploaded_images
    @product.images.each do |image|
      File.delete(image.url) if File.exist?(image.url)
    end
  end

  def update_uploaded_images
    delete_uploaded_images
    @product.images.clear
    upload
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :enabled, :discount_price, :permalink, :category_id, images_attributes: [:url])
    end

    def max_allowed_images?
      @product.images.size < MAX_ALLOWED_IMAGES_FOR_A_PRODUCT
    end
end
