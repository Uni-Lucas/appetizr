class UsersController < ApplicationController
    
    def index
    end
    
    def new
        @user = User.new
    end

    def create
      @user = User.new(nombre: params[:user][:nombre], password: params[:user][:password], rutaImgPerfil: "default", esAdmin: false, password_confirmation: params[:user][:password_confirmation])

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
      @user = User.find_by(nombre: session[:username])
    end

    def update
      @user = User.find_by(nombre: session[:username])
      if !@user.update(user_params)
        render :edit, status: unprocessable_entity
      end
    end
    private
    def user_params
        params.require(:user).permit(:nombre, :password, :password_confirmation, :profile_pic)
    end
end
