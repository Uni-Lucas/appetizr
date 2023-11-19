class DishesController < ApplicationController

  def show
    session[:review_referer] = nil
    alleged_dish = Dish.find_by(id: params[:id], restaurant_id: params[:restaurant_id])
    if alleged_dish
      @dish = alleged_dish
    else
      redirect_to request.referer
    end
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
    if @dish.update(dish_params)
      flash[:dishes] = "El plato ha sido modificado" 
      redirect_to edit_restaurant_path(@dish.restaurant_id)
    else
      flash[:fails] = "El plato no ha sido modificado" 
      render :new, status: :unprocessable_entity
    end
  end

  private
  def dish_params
    params.require(:dish).permit(:nombre, :descripcion, :ruta_img_plato, :precio)
  end
end
