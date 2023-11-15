class PostResponsesController < ApplicationController
  include QueriesConcern
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
    @post_responses = @post.responses.find_each
    puts @post_responses.inspect
    @posts_reactions = {}
    @likes = get_all_reactions("AND respondable_id=#{@post.id} AND respondable_type='Post'", 'responses', 'Response', 'Like')
    @dislikes = get_all_reactions("AND respondable_id=#{@post.id} AND respondable_type='Post'", 'responses', 'Response', 'Dislike')
    @post_responses.with_index do |post, i|
      @posts_reactions[post.id] = {likes: @likes[i]["react"], dislikes: @dislikes[i]["react"]} 
    end
    @posts_reactions[@post.id] = {likes: @post.reactions.where(reaccion: "Like").length(), dislikes: @post.reactions.where(reaccion: "Dislike").length(), responses: @post_responses.size()}
    puts @posts_reactions.inspect
  end







  private
  def post_response_params
    params.require(:post_response).permit(:post_id, :autor, :contenido, :ruta_img)
  end
end
