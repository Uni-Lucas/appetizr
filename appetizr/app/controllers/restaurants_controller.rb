class RestaurantsController < ApplicationController
    def index
        @restaurants = Restaurant.all
    end

    def show
        @restaurant = Restaurant.find(params[:id])
    end

    def new
        @restaurant = Restaurant.new
    end

    def edit
        @restaurant = Restaurant.find(params[:id])
        @r_user = User.find_by(nombre: session[:username])
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

    private
    
    def restaurant_params
        params.require(:restaurant).permit(:categoria, :nombre, :rutaImgFondo, :direccion, :telefono, :horario)
    end
end
