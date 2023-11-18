# app/controllers/admin_control# app/controllers/admin_controller.rb
# app/controllers/admin_controller.rb
class AdminController < ApplicationController
    def dashboard
        @num_posts_last_month = Post.where("created_at > ?", 1.month.ago).count
        @num_reviews_last_month = Review.where("created_at > ?", 1.month.ago).count
        @num_responses_last_month = Response.where("created_at > ?", 1.month.ago).count
        @num_comments_last_month = @num_posts_last_month + @num_reviews_last_month + @num_responses_last_month
        @num_users = User.count
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

    def borrar_restaurante
      # borrar entrada de gestionados
      # borrar posts relacionados con el restaurante
      # borrar respuestas asociadas al post
      # borrar reviews relacionadas con el restaurante
      # borrar respuestas asociadas a las reviews
      # borrar platos asociados al restaurante
      # borrar valoraciones del restaurante
      # borrar entrada del restaurante
    end

    def borrar_categoria
      # borrar posts de la categoria
      # borrar respuestas de los posts
    end

    def borrar_plato
      # borrar entrada del plato
      # borrar reviews del plato 
      # borrar respuestas de las reviews
    end

    def borrar_post
      # borrar respuestas
      # borrar reacciones
      # borrar entrada del post
    end
  
    def borrar_review
      # borrar respuestas
      # borrar reacciones
      # borrar entrada de la review
    end
end
  
  
  
  
  
