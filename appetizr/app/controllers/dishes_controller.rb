class DishesController < ApplicationController
  include QueriesConcern
  def show
    session[:review_referer] = nil
    @restaurant = Restaurant.find(params[:restaurant_id])
    alleged_dish = Dish.find_by(id: params[:id], restaurant_id: params[:restaurant_id])
    if alleged_dish
      @dish = alleged_dish
    else
      redirect_to request.referer
    end
    @reviews_reactions = get_comment_pack(@dish.reviews.find_each, 'reviews', 'Review', "AND reviewable_type='Dish' AND reviewable_id=#{@dish.id}")
    @reviews_user_reactions = get_user_reactions_pack('reviews', 'Review', session[:username], "AND reviewable_id=#{@dish.id} AND reviewable_type='Dish'")
  end

  def new
    @dish = Dish.new
    session[:dish_restaurant] = params[:restaurant_id]
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def create
    nombre_imagen = subir_imagen(params.require(:dish)[:ruta_img_plato])
    @dish = Dish.new(dish_params.merge(ruta_img_plato: nombre_imagen, restaurant_id: session[:dish_restaurant]))
    if @dish.save
      redirect_to restaurant_path(session[:dish_restaurant])
    else
      flash[:fails] = "El plato no ha sido creado" 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def update
    @dish = Dish.find(params[:id])
    if params.require(:dish)[:ruta_img_plato].present?
      nombre_imagen = subir_imagen(params.require(:dish)[:ruta_img_plato])
      update_params = dish_params.merge(ruta_img_plato: nombre_imagen)
    else
      update_params = dish_params
    end
    if @dish.update(update_params)
      flash[:dishes] = "El plato ha sido modificado" 
      redirect_to restaurant_path(@dish.restaurant_id)
    else
      flash[:fails] = "El plato no ha sido modificado" 
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @dish = Dish.find(params[:id])
    @dish.destroy
  end

  private
  def dish_params
    params.require(:dish).permit(:nombre, :descripcion, :ruta_img_plato, :precio)
  end
end
