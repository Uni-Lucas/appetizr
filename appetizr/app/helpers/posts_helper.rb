module PostsHelper
    def get_restaurant_of_post(post)
        if post.restaurant_id
            return Restaurant.find(post.restaurant_id)
        else
            return nil
        end
    end
end
