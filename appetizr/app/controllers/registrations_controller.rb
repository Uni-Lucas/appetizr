class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(nombre: params[:user][:nombre], password: params[:user][:password], rutaImgPerfil: "default", esAdmin: false)

    if @user.save
      session[:username] = @user.nombre
      redirect_to root_path, notice: "Cuenta creada"
    else
      render :new
    end
  end

  private 
  def user_params
    params.require(:user).permit(:nombre, :password)
  end
end
