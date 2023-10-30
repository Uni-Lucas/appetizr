module ApplicationHelper
    def getCurrentUser
        User.find(session[:username])
    end
end
