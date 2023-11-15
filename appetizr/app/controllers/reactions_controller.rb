class ReactionsController < ApplicationController
  def create
    if !session[:username]
      redirect_to login_path
      return
    end
    reaction = Reaction.new(reaction_params)
    reaction.who = session[:username]
    puts reaction
    if reaction.valid? && reaction.save
      flash[:notice] = "Se ha registrado tu reaccion"
    end
    redirect_to request.referer 
  end

  def update
    if !session[:username]
      redirect_to login_path
      return
    end
    @reaction = Reaction.find_by(who: session[:username], reactionable_id: params[:reaction][:reactionable_id], reactionable_type: params[:reaction][:reactionable_type])
    if Reaction.update(@reaction.id, reaccion: params[:reaction][:reaccion])
      redirect_to request.referer 
    end
  end

  private
  def reaction_params
    params.require(:reaction).permit(:reaccion, :reactionable_type, :reactionable_id)
  end
end
