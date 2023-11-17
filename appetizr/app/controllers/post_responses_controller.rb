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
    @post_responses_reactions = get_comment_pack(@post_responses, 'responses', 'Response', "AND respondable_id=#{@post.id} AND respondable_type='Post'")
    @post_responses_user_reactions = get_user_reactions_pack('responses', 'Response', session[:username], "AND respondable_id=#{@post.id} AND respondable_type='Post'")
    @post_responses_reactions[@post.id] = {likes: @post.reactions.where(reaccion: "Like").length(), dislikes: @post.reactions.where(reaccion: "Dislike").length(), responses: @post_responses.size()}
    user_reaction_id = @post.reactions.find_by(who: session[:username])
    if user_reaction_id
      @post_responses_user_reactions[@post.id] = {reaction_id: user_reaction_id.id}
    else
      @post_responses_user_reactions[@post.id] = {}
    end
  end







  private
  def post_response_params
    params.require(:post_response).permit(:post_id, :autor, :contenido, :ruta_img)
  end
end
