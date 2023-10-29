class PostsController < ApplicationController
  def new
    @post = Post.new
    session[:post_category] = params[:category]
  end

  def create
    @post = Post.new(categoria: session[:post_category], autor: session[:username], contenido: params[:post][:content], ruta_img: params[:post][:image], created_at: Time.now, updated_at: Time.now)

    session[:post_category] = nil
    if @post.save
      redirect_to category_path(@post.categoria), notice: "All good"
    else
      render :new
    end
  end

end
