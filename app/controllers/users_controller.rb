class UsersController < ApplicationController
  before_action :check_user
  before_action :load_user

  private

  def check_user
    if session[:user_id] && !Player.find_by(id: session[:user_id])
      session[:user_id] = nil
    end
  end

  def load_user
    @user = (Player.find(session[:user_id]) if session[:user_id])
  end
end

