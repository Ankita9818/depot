class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_pagination_elements, only: :line_items
  layout "myusers", only: [:line_items, :orders]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /users/1/edit
  def edit
    @user.build_address unless @user.address.present?
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_create_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_edit_params)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, notice: @user.errors.full_messages.join(', ') }
        format.json { head :no_content }
      end
    end
  end

  def line_items
    @line_items = current_user.paginate_items(@items_per_page, @page_number)
  end

  def orders
    @orders = current_user.orders.includes(line_items: :product)
  end

  rescue_from 'User::Error' do |exception|
    redirect_to users_url, notice: exception.message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_create_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, address_attributes: [:state, :city, :country, :pincode])
    end

    def user_edit_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, address_attributes: [:id, :state, :city, :country, :pincode])
    end

    def set_pagination_elements
      @items_per_page = get_param_as_integer(params[:items_per_page]) || 5
      @page_number = get_param_as_integer(params[:page_number]) || 1
    end

    def get_param_as_integer(param_item)
      param_item.to_i if ( param_item != '0' && (param_item.to_i.to_s == param_item) )
    end
end
