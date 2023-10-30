module LoginsHelper
    def log_in(user)
        session[:username] = user.nombre
      end
    
      def current_user
        if session[:username]
          @current_user ||= User.find_by(nombre: session[:username])
        end
      end
    
      def logged_in?
        !current_user.nil?
      end
    
      def log_out
        session.delete(:nombre)
        @current_user = nil
      end
    
      def current_user?(user)
        user == current_user
      end
    
      def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
      end
    
      def store_location
        session[:forwarding_url] = request.original_url if request.get?
      end
end
