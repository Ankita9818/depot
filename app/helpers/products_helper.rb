module ProductsHelper
  def rating_request_method(product)
    if rating = product.ratings.find_by(user_id: current_user.id)
      ['put', rating_url(rating)]
    else
      ['post', ratings_url]
    end
  end
end
