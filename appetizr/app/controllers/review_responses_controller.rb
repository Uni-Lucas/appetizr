class ReviewResponsesController < ApplicationController
  def index
    @review = Review.find(params[:review_id])
  end
end
