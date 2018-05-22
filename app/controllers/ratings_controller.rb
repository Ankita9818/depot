class RatingsController < ApplicationController
  before_action :set_rating, only: :update

  def update
    @rating.score = params[:score]
    respond_to do |format|
      if @rating.save
        format.json { render json: { message: 'The Product rating  has been successfully updated'} }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @rating = Rating.new(rating_create_params)
    @rating.user = current_user
    respond_to do |format|
      if @rating.save
        format.json { render json: { message: 'The Product has been successfully rated'} }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  private def rating_create_params
    params.permit(:product_id, :score)
  end

  private def set_rating
    @rating = current_user.ratings.find_by(product_id: params[:product_id])
  end
end
