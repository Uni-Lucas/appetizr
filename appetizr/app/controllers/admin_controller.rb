# app/controllers/admin_control# app/controllers/admin_controller.rb
# app/controllers/admin_controller.rb
class AdminController < ApplicationController
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
  
    private
end
  
  
  
  
  