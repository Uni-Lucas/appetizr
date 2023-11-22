class RanksController < ApplicationController
  def create
    rank = Rank.new(who: session[:username], what: params[:restaurant_id], valoracion: params[:rank])
    if rank.save
      redirect_to restaurant_path(params[:restaurant_id])
    else
      flash[:errors] = "No se pudo valorar el restaurante"
    end
  end
end
