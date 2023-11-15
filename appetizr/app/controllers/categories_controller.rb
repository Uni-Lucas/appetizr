class CategoriesController < ApplicationController
  include QueriesConcern
  def index 
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:nombre])
    @category_posts = @category.posts.find_each
    @posts_reactions = {}
    @likes = get_all_reactions("AND categoria='#{params[:nombre]}'", 'posts', 'Post', 'Like')
    @dislikes = get_all_reactions("AND categoria='#{params[:nombre]}'", 'posts', 'Post', 'Dislike')
    @responses = get_all_responses("AND categoria='#{params[:nombre]}'", 'posts', 'Post')
    @category_posts.with_index do |post, i|
      @posts_reactions[post.id] = {likes: @likes[i]["react"], dislikes: @dislikes[i]["react"], responses: @responses[i]["resp_count"]} 
    end
    session[:post_category] = params[:nombre]
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

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
    if @category.update(category_params)
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
      params.require(:category).permit(:nombre, :photo)
    end
end
