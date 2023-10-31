class NearmeController < ApplicationController
    def index
        @api_key = 'AIzaSyAqOnMdlNZyHQPIsoR9oAL_uAli5t-cGjQ'
    end

    private
    
    def search_nearby_restaurants(latitude, longitude)
        api_key = 'AIzaSyAqOnMdlNZyHQPIsoR9oAL_uAli5t-cGjQ' # Reemplaza con tu clave API de Google Places
        radius = 1000 # Radio de búsqueda en metros
        type = 'restaurant' # Tipo de lugar (restaurantes)
      
        url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{latitude},#{longitude}&radius=#{radius}&type=#{type}&key=#{api_key}"
      
        response = JSON.parse(open(url).read)
        return response['results']
    end

    


end