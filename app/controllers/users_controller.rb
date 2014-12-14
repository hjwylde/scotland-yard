class UsersController
  class Base < ApplicationController
    before_action :check_user
    before_action :load_user

    private

    def check_user
      # TODO: Make a user model, don't use players...
      if session[:user_id] && !Player.find_by(id: session[:user_id])
        session[:user_id] = nil
      end
    end

    def load_user
      @current_user = (Player.find(session[:user_id]) if session[:user_id])
    end

    def current_user
      @current_user
    end
  end
end

