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
    session[:dish_restaurant] = params[:restaurant]
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.restaurant_id = session[:dish_restaurant] 
    if @dish.save
      session[:dish_restaurant] = nil
      flash[:dishes] = "Nuevo plato creado" 
      redirect_to edit_restaurant_path(@dish.restaurant_id)
    else
      flash[:fails] = "Plato no se ha podido crear"
      render :new 
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
