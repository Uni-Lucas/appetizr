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
        # Realizar la llamada a la API y obtener los datos
        rutaAPI = 'https://172.20.10.8/api/restaurantes'
        response = RestClient.get rutaAPI, { accept: :json }
        api_data = JSON.parse(response.body)
    
        api_data.each do |api_restaurante|
            # Buscar si ya existe un restaurante con el mismo nombre y teléfono
            restaurante = Restaurant.find_by(nombre: api_restaurante['nombre'], telefono: api_restaurante['telefono'])
  
            if restaurante.nil?
                # Si no existe, crear un nuevo restaurante
                restaurante = Restaurant.new(
                    categoria: api_restaurante['categoria'],
                    nombre: api_restaurante['nombre'],
                    direccion: api_restaurante['direccion'],
                    telefono: api_restaurante['telefono'],
                    # Otros atributos...
                    id_api: api_restaurante['idrestaurante']
                )
                restaurante.save
            end
        end
  
        redirect_to admin_dashboard_path, notice: 'Datos actualizados correctamente'
    end

    def promote
      Rails.application.config.promoted_restaurant = params[:restaurant_id]
      redirect_to '/admin', notice: 'Restaurante promocionado correctamente'
    end
end
  
  
  
  
  
