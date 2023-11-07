class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @review.reviewable_id = params[:review_to]
    @review.reviewable_type = params[:review_type]
    @review.autor = session[:username]
    session[:review_referer] = request.referer
  end

  def create
    if params[:review][:ruta_img]
      nombre_imagen = subir_imagen(params.require(:review)[:ruta_img])
    else
      nombre_imagen = "default"
    end
    original_reviewed = get_original_reviewed(params[:review][:reviewable_id], params[:review][:reviewable_type])
    if original_reviewed
      @review = Review.new(review_params)
      @review.ruta_img = nombre_imagen
      @review.created_at = Time.now 
      @review.updated_at = Time.now 
      # La ruta de la imagen hay que meterla
      if @review.save
        redirect_to session[:review_referer] 
      end
    end
  end
  private
  def get_original_reviewed(id, type)
    if type == "Dish"
      return Dish.find(id)
    else
      return Restaurant.find(id)
    end
  end
  def review_params 
    params.require(:review).permit(:reviewable_id, :reviewable_type, :contenido, :ruta_img, :autor)
  end
end
