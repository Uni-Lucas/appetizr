# app/controllers/admin_control# app/controllers/admin_controller.rb
# app/controllers/admin_controller.rb
class AdminController < ApplicationController
    def dashboard
        @num_posts_last_month = Post.where("created_at > ?", 1.month.ago).count
        @num_reviews_last_month = Review.where("created_at > ?", 1.month.ago).count
        @num_responses_last_month = Response.where("created_at > ?", 1.month.ago).count
        @num_comments_last_month = @num_posts_last_month + @num_reviews_last_month + @num_responses_last_month
        @num_users = User.count
        @users = User.all
        @restaurants = Restaurant.all
    end
    
    def actualizar_datos
        # Realizar la llamada a la API para obtiener todos los restaurantes
        restaurants= RestClient.get ENV[Rails.application.config.EINAEATS_GET_ALL_RESTAURANTS]
        restaurants.each do |restaurant|
            # Para cada restaurante, realizar una llamada a nuestra api para crearlo o actualizarlo
            #@app.route('/restaurants/<imported_id>/<new_nombre>/<new_telefono>/<new_categoria>/<new_horario>/<new_direccion>', methods=['PUT'])
            rutaAPI = ENV[Rails.application.config.APPETIZR_API] + '/restaurants/' + restaurant['idrestaurante'] + '/' + restaurant['nombre'] + '/' + restaurant['telefono'] + '/' + restaurant['categoria'] + '/' + restaurant['horario'] + '/' + restaurant['direccion']
            response = RestClient.put rutaAPI, { accept: :json }

            # Realizar la llamada a la API para obtener todos los platos de cada restaurante
            dishes= RestClient.get ENV[Rails.application.config.EINAEATS_GET_ALL_DISHES_FROM_RESTAURANT] + restaurant['idrestaurante']
            dishes.each do |dish|
                # Para cada plato, realizar una llamada a nuestra api para crearlo o actualizarlo
                #@app.route('/dishes/<imported_id_res>/<imported_id_dish>/<new_nombre_dish>/<new_descripcion>/<new_precio>', methods=['PUT'])
                rutaAPI = ENV[Rails.application.config.APPETIZR_API] + '/dishes/' + restaurant['idrestaurante'] + '/' + dish['iddish'] + '/' + dish['nombre'] + '/' + dish['descripcion'] + '/' + dish['precio']
                response = RestClient.put rutaAPI, { accept: :json }
            end
        end
        redirect_to admin_dashboard_path, notice: 'Datos actualizados correctamente'
    end


    def promote
      Rails.application.config.promoted_restaurant = params[:restaurant_id]
      redirect_to '/admin', notice: 'Restaurante promocionado correctamente'
    end
end
  
  
  
  
  
