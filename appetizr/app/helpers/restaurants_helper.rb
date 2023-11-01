module RestaurantsHelper
  def get_rest_manager
    User.find_by(nombre: session[:username])
  end
  def get_total_reviews(rest)
    rest_revs = rest.reviews.length()
    acc_dish_revs = 0
    rest.dishes.each do |dish| 
      acc_dish_revs += dish.reviews.length()
    end
    rest_revs+acc_dish_revs
  end
end
