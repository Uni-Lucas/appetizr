class UsersController < ApplicationController
    
    def index
    end
    
    def new
        @user = User.new
    end

    def is_restaurant_owner
    end


    def create
      nombre_imagen = subir_imagen(params.require(:user)[:ruta_img_perfil])
      @user = User.new(nombre: params[:user][:nombre], password: params[:user][:password], ruta_img_perfil: nombre_imagen, esAdmin: false, password_confirmation: params[:user][:password_confirmation])

      if @user.save
        session[:username] = @user.nombre
        redirect_to is_rest_owner_path, notice: "Cuenta creada"
      else
        render :new, status: unprocessable_entity
      end
    end

    def show
        @user = User.find_by(nombre: session[:username])
        # Numero de posts que ha hecho
        @num_posts = Post.where(autor: @user.id).count
        
        # Numero de platos y restaurantes sobre los que ha comentado
        @num_reviews = Review.where(autor: @user.id).count
        
        # Numero de respuestas que ha hecho
        @num_responses = Response.where(autor: @user.id).count

        # Numero de comentarios totales en el último mes
        @num_comments_last_month = 
          Post.where(autor: @user.id).where("created_at > ?", 1.month.ago).count +
          Review.where(autor: @user.id).where("created_at > ?", 1.month.ago).count + 
          Response.where(autor: @user.id).where("created_at > ?", 1.month.ago).count

        # Si el usuario es propietario de restaurantes, se calculan las estadísticas de sus restaurantes
        @num_restaurants_user = @user.restaurants.count

        @num_reviews_restaurant_last_month = 0
        @num_reviews_dishes_last_month = 0
        @num_responses_restaurant_last_month = 0
        @num_likes_restaurant_last_month = 0
        @num_dislikes_restaurant_last_month = 0
        
        if @num_restaurants_user > 0
          @user.restaurants.each do |restaurant|
            @num_reviews_restaurant_last_month += Review.where(reviewable_id: restaurant.id, reviewable_type: 'Restaurant').where("created_at > ?", 1.month.ago).count
            # MODIFICAR: reviewable_id tiene que ser un plato de restaurant
            restaurant.dishes.each do |dish|
              @num_reviews_dishes_last_month += Review.where(reviewable_id: dish.id, reviewable_type: 'Dish').where("created_at > ?", 1.month.ago).count
            end
            @num_likes_restaurant_last_month += Reaction.where(who: restaurant.id).where(reaccion: 'Like').count
            @num_dislikes_restaurant_last_month += Reaction.where(who: restaurant.id).where(reaccion: 'Dislike').count
          end
        end
    end

    def update
      @user = User.find_by(nombre: session[:username])
      nombre_imagen = subir_imagen(params.require(:user)[:ruta_img_perfil])
      
      if !@user.update(user_params.merge(ruta_img_perfil: nombre_imagen))
        render :edit, status: unprocessable_entity
      else 
        redirect_to user_path(@user.nombre), notice: "Perfil actualizado"
      end
    end

    def destroy
      @user = User.find_by(nombre: )
    end
    
    def mis_restaurantes
      @user = User.find_by(nombre: session[:username])
      @restaurants = @user.restaurants
      
      render :mis_restaurantes
    end

    private
    def user_params
        params.require(:user).permit(:nombre, :password, :password_confirmation, :ruta_img_perfil)
    end
end
