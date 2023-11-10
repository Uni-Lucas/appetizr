module RestaurantsHelper
  def get_rest_managers_posts(rest_id)
    results = ActiveRecord::Base.connection.execute("SELECT posts.* FROM posts, users, restaurants_users as ru WHERE ru.user_id=users.nombre AND ru.restaurant_id=#{rest_id} AND posts.autor=users.nombre AND posts.restaurant_id=#{rest_id}")
    vals = results.values.map{|post| Post.new(id: post[0], categoria: post[1], autor: post[2], contenido: post[3], ruta_img: post[4], created_at: post[5], updated_at: post[6])}
    return vals
  end
  def get_total_reviews(rest)
    rest_revs = rest.reviews.length()
    acc_dish_revs = 0
    rest.dishes.each do |dish| 
      acc_dish_revs += dish.reviews.length()
    end
    rest_revs+acc_dish_revs
  end
end
