class PostResponsesController < ApplicationController
  def new
    @post_response = PostResponse.new
  end
  
  
  def create
    nombre_imagen = subir_imagen(params.require(:post_response)[:image])
    usuario = User.find_by(nombre: session[:username])
    @post_response = PostResponse.new(post_id: params[:post_id], autor: session[:username], contenido: params[:post_response][:content], ruta_img: nombre_imagen, created_at: Time.now, updated_at: Time.now)
  
    if @post_response.save
      redirect_to post_path(params[:post_id]), notice: "All good"
    else
      render :new
    end
  end
   
  def index
    session[:response_referer] = nil
    @post = Post.find(params[:post_id])
  end







  private
  def post_response_params
    params.require(:post_response).permit(:post_id, :autor, :contenido, :ruta_img)
  end
end
