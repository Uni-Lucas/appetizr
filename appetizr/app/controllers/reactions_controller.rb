class ReactionsController < ApplicationController
  def create
    reaction = Reaction.new(reaction_params)
    reaction.who = session[:username]
    puts reaction
    if reaction.valid? && reaction.save
      flash[:notice] = "Se ha registrado tu reaccion"
    end
    redirect_to request.referer 
  end

  def update
    reaction = Reaction.new(reaction_params)
    reaction.who = session[:username]
    if !reaction.valid?
      reaction.update()
    end
    redirect_to request.referer 
  end

  private
  def reaction_params
    params.require(:reaction).permit(:reaccion, :reactionable_type, :reactionable_id)
  end
end
