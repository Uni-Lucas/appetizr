class UsersController < ApplicationController
    
    def index
    end
    
    def new
        @user = User.new
    end

    def create
      nombre_imagen = subir_imagen(params.require(:user)[:ruta_img_perfil])
      @user = User.new(nombre: params[:user][:nombre], password: params[:user][:password], ruta_img_perfil: nombre_imagen, esAdmin: false, password_confirmation: params[:user][:password_confirmation])

      if @user.save
        session[:username] = @user.nombre
        redirect_to root_path, notice: "Cuenta creada"
      else
        render :new, status: unprocessable_entity
      end
    end

    def show
        @user = User.find_by(nombre: session[:username])
    end

    def update
      nombre_imagen = subir_imagen(params.require(:user)[:ruta_img_perfil])
      @user = User.find_by(nombre: session[:username])
      
      if !@user.update(user_params)
        render :edit, status: unprocessable_entity
      end
    end
    private
    def user_params
        params.require(:user).permit(:nombre, :password, :password_confirmation, :ruta_img_perfil)
    end
end
