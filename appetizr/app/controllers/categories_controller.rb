class CategoriesController < ApplicationController
  def index 
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:nombre])
    @category_posts = @category.posts.find_each
    @posts_reactions = {}
    @likes = ActiveRecord::Base.connection.execute("SELECT posts.id, COUNT(reaccion) as react FROM posts LEFT JOIN reactions ON reactionable_id=posts.id AND reactionable_type='Post' AND reaccion='Like' AND categoria='#{params[:nombre]}' GROUP BY posts.id ORDER BY posts.created_at DESC")
    @dislikes = ActiveRecord::Base.connection.execute("SELECT posts.id, COUNT(reaccion) as react FROM posts LEFT JOIN reactions ON reactionable_id=posts.id AND reactionable_type='Post' AND reaccion='Dislike' AND categoria='#{params[:nombre]}' GROUP BY posts.id ORDER BY posts.created_at DESC")
    @category_posts.with_index do |post, i|
      @posts_reactions[post.id] = {likes: @likes[i]["react"], dislikes: @dislikes[i]["react"]} 
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
