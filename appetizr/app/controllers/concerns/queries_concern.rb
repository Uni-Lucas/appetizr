module QueriesConcern
  extend ActiveSupport::Concern

  def get_all_reactions(wheres, tabla, tipo, reaccion)
    ActiveRecord::Base.connection.execute("SELECT #{tabla}.id, COUNT(reaccion) as react FROM #{tabla} LEFT JOIN reactions ON reactionable_id=#{tabla}.id AND reactionable_type='#{tipo}' AND reaccion='#{reaccion}' #{wheres} GROUP BY #{tabla}.id ORDER BY #{tabla}.id ASC ")
  end
  
  def get_all_responses(wheres, tabla, tipo)
    ActiveRecord::Base.connection.execute("SELECT #{tabla}.id, COUNT(responses.id) as resp_count FROM #{tabla} LEFT JOIN responses ON respondable_id=#{tabla}.id AND respondable_type='#{tipo}' #{wheres} GROUP BY #{tabla}.id ORDER BY #{tabla}.id ASC")
  end

end
