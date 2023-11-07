class ReviewResponsesController < ApplicationController
  def index
    session[:response_referer] = nil
    @review = Review.find(params[:review_id])
  end
end
