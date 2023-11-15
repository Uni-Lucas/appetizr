class ReviewResponsesController < ApplicationController
  def index
    session[:response_referer] = nil
    @review = Review.find(params[:review_id])
    @review_responses = @review.responses.find_each
    @reviews_reactions = {}
    @likes = get_all_reactions("AND respondable_id=#{@review.id} AND respondable_type='Review'", 'responses', 'Response', 'Like')
    @dislikes = get_all_reactions("AND respondable_id=#{@review.id} AND respondable_type='Review'", 'responses', 'Response', 'Dislike')
    @category_reviews.with_index do |review, i|
      @reviews_reactions[review.id] = {likes: @likes[i]["react"], dislikes: @dislikes[i]["react"]} 
    end
  end
end
