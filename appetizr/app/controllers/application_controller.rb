class ApplicationController < ActionController::Base
   
    def subir_imagen(imagen)
        begin
          nombre_imagen = SecureRandom.hex(10) + File.extname(imagen.original_filename)
          ruta = File.join("app", "assets", "images", nombre_imagen)
          File.open(ruta, "wb") do |f| 
             f.write(imagen.read)
          end
          nombre_imagen
        
        rescue => e
          Rails.logger.error "Error al subir la imagen: #{e.message}"
          nil
        end
    end
end
