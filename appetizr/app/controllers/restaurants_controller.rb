class RestaurantsController < ApplicationController
    include QueriesConcern
    def index
      if params[:filter]
        @restaurants = Restaurant.where(categoria: params[:filter]) 
      else
        @restaurants = Restaurant.all
      end
        @categories = Category.all
        rats = Restaurant.joins(:ranks).select(:what, "AVG(valoracion) as rest_val").group(:what)
          # Si no hay valoraciones, se pone a 0
          if rats.empty?
            @ratings = nil
          else
            @ratings = rats
          end
        tops = Rank.select(:what, "AVG(valoracion) as total_valoracion").group(:what).order("total_valoracion DESC") 
        @tops = tops.map{|r| Restaurant.find(r.what)}.compact
    end

    def show
        @restaurant = Restaurant.find_by(id: params[:id])
        if !@restaurant
          redirect_to "/not_found" 
          return
        end
        rats = Rank.select(:what, "AVG(valoracion) as rest_val").where(what: @restaurant.id).group(:what)
        # Si no hay valoraciones, se pone a 0
        if rats.empty?
          @ratings = nil
        else
          @ratings = rats[0].rest_val
        end
        @posts_reactions = get_comment_pack(@restaurant.posts.find_each, 'posts', 'Post', "AND restaurant_id=#{@restaurant.id}")
        @posts_user_reactions = get_user_reactions_pack('posts', 'Post', session[:username], "AND restaurant_id=#{@restaurant.id}")
        @reviews_reactions = get_comment_pack(@restaurant.reviews.find_each, 'reviews', 'Review', "AND reviewable_id=#{@restaurant.id} AND reviewable_type='Restaurant'")
        @reviews_user_reactions = get_user_reactions_pack('reviews', 'Review', session[:username], "AND reviewable_id=#{@restaurant.id} AND reviewable_type='Restaurant'")
    end

    def new
        @restaurant = Restaurant.new
    end

    def create
        nombre_imagen = subir_imagen(params.require(:restaurant)[:ruta_img_fondo])
        @restaurant = Restaurant.new(restaurant_params.merge(ruta_img_fondo: nombre_imagen))
        if @restaurant.save
            redirect_to @restaurant
          else
            render :new, status: :unprocessable_entity
          end
        @restaurant.users << User.find_by(nombre: session[:username])
    end

    def edit
        @restaurant = Restaurant.find(params[:id])
    end

    def update 
        @restaurant = Restaurant.find(params[:id])
        nombre_imagen = subir_imagen(params.require(:restaurant)[:ruta_img_fondo])
        if @restaurant.update(restaurant_params.merge(ruta_img_fondo: nombre_imagen))
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
            @restaurant= Restaurant.where("lower(nombre) LIKE ?", "%#{params[:search].downcase}%")

            #@restaurant = Restaurant.find_by(nombre: params[:search])
            if @restaurant
                redirect_to @restaurant[0]
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
