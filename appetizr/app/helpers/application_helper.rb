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

    def define_turbo_method(comment)
      if comment.reactions.find_by(who: session[:username])
        return :put
      else
        return :post
      end
    end

    def reaction_action_path(locals)
      reaction = {reaccion: locals[:button], reactionable_type: get_comment_type(locals[:comment]), reactionable_id: locals[:comment].id}
      if locals[:comment].reactions.find_by(who: session[:username])
        return reaction_path(reaction: reaction)
      else
        return reactions_path(reaction: reaction)
      end
    end
end
