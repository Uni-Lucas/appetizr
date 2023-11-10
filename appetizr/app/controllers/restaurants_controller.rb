class RestaurantsController < ApplicationController
    def index
      if params[:filter]
        @restaurants = Restaurant.where(categoria: params[:filter]) 
      else
        @restaurants = Restaurant.all
      end
        @categories = Category.all
        tops = Rank.select(:what, "AVG(valoracion) as total_valoracion").group(:what).order("total_valoracion DESC") 
        @tops = tops.map{|r| Restaurant.find(r.what)}.compact
    end

    def show
        @restaurant = Restaurant.find(params[:id])
        rats = Rank.select(:what, "AVG(valoracion) as rest_val").where(what: @restaurant.id).group(:what)
        @ratings = rats[0].rest_val
    end

    def new
        @restaurant = Restaurant.new
    end

    def edit
        @restaurant = Restaurant.find(params[:id])
    end

    def update 
        @restaurant = Restaurant.find(params[:id])
        if @restaurant.update(restaurant_params)
            redirect_to @restaurant
          else
            render :new, status: :unprocessable_entity
          end
    end

    def destroy
        @restaurant = Restaurant.find(params[:id])
        @restaurant.destroy

        redirect_to root_path, status: :see_other
    end

    def search
        if params[:search]
            @restaurant = Restaurant.find_by(nombre: params[:search])
            if @restaurant
                redirect_to @restaurant
            else 
                # flash.now[:notice] = "No se encontró ningún restaurante con ese nombre"
                redirect_to categories_path
            end
        else
            render :index
        end
    end

    def stats
      @restaurant = Restaurant.find(params[:id])
    end

    def edit_info
      @restaurant = Restaurant.find(params[:id])
    end

    private
    
    def restaurant_params
        params.require(:restaurant).permit(:categoria, :nombre, :ruta_img_fondo, :direccion, :telefono, :horario, :image)
    end
end
