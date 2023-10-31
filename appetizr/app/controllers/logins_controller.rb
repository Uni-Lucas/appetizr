class LoginsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(nombre: params[:nombre]) 
    if user.present? && user.authenticate(params[:password])
      helpers.log_in(user)
      redirect_to root_path, notice: "Logged in"
    else
      flash.now[:alert] = "Nombre o contraseña invalidos"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private 
    def user_params
      params.require(:user).permit(:nombre, :password)
      # devolver nombre y contrasegna codificada
    end
end
