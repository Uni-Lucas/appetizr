module ApplicationHelper
    def getCurrentUser
        User.find(session[:username])
    end

    def is_not_response(comment)
      !comment.is_a?(Response) 
    end

    def get_response_path(comment)
      if comment.is_a?(Review)
        return review_responses_path(review_id: comment.id)
      else
        return post_responses_path(post_id: comment.id)
      end
    end

    def get_comment_type(comment)
      if comment.is_a?(Review)
        return "Review"
      else
        return "Post"
      end
    end

    def get_number_of_responses(comment)
      comment.responses.length()
    end

    def get_number_of_likes(comment)
      comment.reactions.where(reaccion: "Like").length()
    end

    def get_number_of_dislikes(comment)
      comment.reactions.where(reaccion: "Dislike").length()
    end
end
