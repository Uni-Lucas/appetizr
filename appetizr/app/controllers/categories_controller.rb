class CategoriesController < ApplicationController
  include QueriesConcern
  def index 
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:nombre])
    @category_posts = @category.posts.find_each
    @posts_reactions = get_comment_pack(@category_posts, 'posts', 'Post', "AND categoria='#{params[:nombre]}'")
    @comments_user_reactions = get_user_reactions_pack('posts', 'Post', session[:username], "AND categoria='#{params[:nombre]}'")
        #  for every comment, check whether a user has already reacted to that comment
    session[:post_category] = params[:nombre]
  end

  def new
    @category = Category.new
  end

  def create
    nombre_imagen = subir_imagen(params.require(:category)[:ruta_img])
    @category = Category.new(nombre: params[:category][:nombre], ruta_img: nombre_imagen)

    if @category.save
      redirect_to @category
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:nombre])
  end

  def update
    @category = Category.find(params[:nombre])
    nombre_imagen = subir_imagen(params.require(:category)[:ruta_img])
    if @category.update(category_params.merge(ruta_img: nombre_imagen))
      redirect_to @category
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy 
    @category = Category.find(params[:nombre])
    @category.destroy

    redirect_to root_path, status: :see_other
  end

  private 
    def category_params
      params.require(:category).permit(:nombre, :ruta_img)
    end
end
