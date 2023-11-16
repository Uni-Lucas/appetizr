module QueriesConcern
  extend ActiveSupport::Concern

  def get_all_reactions(wheres, tabla, tipo, reaccion)
    ActiveRecord::Base.connection.execute("SELECT #{tabla}.id, COUNT(reaccion) as react FROM #{tabla} LEFT JOIN reactions ON reactionable_id=#{tabla}.id AND reactionable_type='#{tipo}' AND reaccion='#{reaccion}' #{wheres} GROUP BY #{tabla}.id ORDER BY #{tabla}.id ASC ")
  end
  
  def get_all_responses(wheres, tabla, tipo)
    ActiveRecord::Base.connection.execute("SELECT #{tabla}.id, COUNT(responses.id) as resp_count FROM #{tabla} LEFT JOIN responses ON respondable_id=#{tabla}.id AND respondable_type='#{tipo}' #{wheres} GROUP BY #{tabla}.id ORDER BY #{tabla}.id ASC")
  end

  def get_comments_user_reactions(wheres, comments, comment_type, user)
    ActiveRecord::Base.connection.execute("SELECT #{comments}.id, reactions.id as reaction_id FROM #{comments} LEFT JOIN reactions ON reactions.who='#{user}' AND reactions.reactionable_id=#{comments}.id AND reactions.reactionable_type='#{comment_type}' #{wheres} GROUP BY #{comments}.id, reaction_id")
  end

  def get_comment_pack(over, table, type, wheres)
    comments_reactions = {}
    likes = get_all_reactions(wheres, table, type, 'Like')
    dislikes = get_all_reactions(wheres, table, type, 'Dislike')
    comments_reactions = {}
    if table != 'responses'
      responses = get_all_responses(wheres, table, type)
      over.each do |post|
        comments_reactions[post.id] = {likes: likes.select {|l| l["id"] == post.id}[0]["react"], dislikes: dislikes.select {|d| d["id"] == post.id}[0]["react"], responses: responses.select {|resp| resp["id"] == post.id}[0]["resp_count"]} 
      end
      else 
        over.each do |post|
          comments_reactions[post.id] = {likes: likes.select {|l| l["id"] == post.id}[0]["react"], dislikes: dislikes.select {|d| d["id"] == post.id}[0]["react"]} 
        end
    end
    return comments_reactions 
  end
  
  def get_user_reactions_pack(table, type, user, wheres)
    raw_comments_user_reactions = get_comments_user_reactions(wheres, table, type, user)
    comments_user_reactions = {}
    raw_comments_user_reactions.each do |r|
      comments_user_reactions[r["id"]] = {reaction_id: r["reaction_id"]}
    end
    return comments_user_reactions
  end
end
