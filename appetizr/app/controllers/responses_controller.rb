class ResponsesController < ApplicationController
  def new
    if !session[:username]
      redirect_to login_path
    end
    @response = Response.new
    @response.respondable_id = params[:response_to]
    @response.respondable_type = params[:response_type]
    @response.autor = session[:username]
    session[:response_referer] = request.referer
  end

  def create
    if params[:response][:ruta_img]
      nombre_imagen = subir_imagen(params.require(:response)[:ruta_img])
    end

    original_comment = get_original_comment(params[:response][:respondable_id], params[:response][:respondable_type])
    
    if original_comment
      @response = Response.new(response_params)
      @response.ruta_img = nombre_imagen
      @response.created_at = Time.now 
      @response.updated_at = Time.now 
      # La ruta de la imagen hay que meterla
      if @response.save
        redirect_to session[:response_referer] 
      end
    end
  end

  private

  def get_original_comment(id, type)
    if type == "Review"
      return Review.find(id)
    else
      return Post.find(id)
    end
  end

  def response_params
    params.require(:response).permit(:respondable_id, :respondable_type, :contenido, :ruta_img, :autor)
  end
end
