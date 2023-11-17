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
      elsif comment.is_a?(Post)
        return "Post"
      else
        return "Response"
      end
    end

    def get_dish_path(dish)
      return restaurant_dish_path(restaurant_id: dish.restaurant_id, id: dish.id)
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

    def define_turbo_method(reaction_id)
      if reaction_id 
        return :put
      else
        return :post
      end
    end

    def reaction_action_path(locals)
      new_reaction = {reaccion: locals[:button], reactionable_type: get_comment_type(locals[:comment]), reactionable_id: locals[:comment].id}
      if locals[:user_reaction_id] 
        return reaction_path(id: locals[:user_reaction_id], reaction: new_reaction)
      else
        return reactions_path(reaction: new_reaction)
      end
    end

end
