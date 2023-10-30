class UsersController < ApplicationController
    
    def index
    end
    
    def new
    end

    def show
        @user = User.find(params[:nombre])
    end
end
