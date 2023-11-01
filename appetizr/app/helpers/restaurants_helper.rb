module RestaurantsHelper
  def get_rest_manager
    User.find_by(nombre: session[:username])
  end
end
