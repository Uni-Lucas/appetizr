class LoginsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(nombre: params[:nombre]) 
    if user.present? && user.authenticate(params[:password])
      session[:username] = user.nombre
      redirect_to root_path, notice: "Logged in"
    else
      flash[:alert] = "Nombre o contraseña invalidos"
      render :new
    end
  end
  private 
    def user_params
      params.require(:user).permit(:nombre, :password)
      # devolver nombre y contrasegna codificada
    end
end
