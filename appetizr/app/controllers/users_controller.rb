class UsersController < ApplicationController
    
    def index
    end
    
    def new
    end

    def show
        @user = User.find_by(nombre: params[:nombre])
    end
end
