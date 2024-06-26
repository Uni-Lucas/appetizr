class PostsController < ApplicationController
  def new
    if !session[:username]
      redirect_to login_path
    end
    @post = Post.new
    user_restos = ActiveRecord::Base.connection.execute("SELECT restaurants.id, restaurants.nombre FROM restaurants, users, restaurants_users as ru WHERE users.nombre='#{session[:username]}' AND users.nombre=ru.user_id AND ru.restaurant_id=restaurants.id ")
    @user_restaurants = user_restos.values.map{|res| Restaurant.new(id: res[0], nombre: res[1])}
  end

  def create
    nombre_imagen = subir_imagen(params.require(:post)[:ruta_img])
    if !session[:username]
      flash[:notice] = "Tienes que logearte para poder crear posts"
      redirect_to category_path(session[:post_category])
    end
    usuario = User.find_by(nombre: session[:username])
    @post = Post.new(categoria: session[:post_category], autor: session[:username], contenido: params[:post][:contenido], ruta_img: nombre_imagen, created_at: Time.now, updated_at: Time.now)
    if params[:post][:asOwnerOf] != "None"
      @post.restaurant_id = params[:post][:asOwnerOf]
    end
    session[:post_category] = nil
    if @post.save
      redirect_to category_path(nombre: @post.categoria), notice: "All good"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer
  end


  private
  def post_params
    params.require(:post).permit(:categoria, :autor, :contenido, :ruta_img, :asOwner)
  end
end
