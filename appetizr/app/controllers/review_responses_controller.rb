class ReviewResponsesController < ApplicationController
  include QueriesConcern
  def index
    session[:response_referer] = nil
    @review = Review.find(params[:review_id])
    @review_responses = @review.responses.find_each
    @review_responses_reactions = get_comment_pack(@review_responses, 'responses', 'Response', "AND respondable_id=#{@review.id} AND respondable_type='Review'")
    @review_responses_user_reactions = get_user_reactions_pack('responses', 'Response', session[:username], "AND respondable_id=#{@review.id} AND respondable_type='Review'")
    @review_responses_reactions[@review.id] = {likes: @review.reactions.where(reaccion: "Like").length(), dislikes: @review.reactions.where(reaccion: "Dislike").length(), responses: @review_responses.size()}
    user_reaction_id = @review.reactions.find_by(who: session[:username])
    if user_reaction_id
      @review_responses_user_reactions[@review.id] = {reaction_id: user_reaction_id.id}
    else
      @review_responses_user_reactions[@review.id] = {}
    end
  end
end
