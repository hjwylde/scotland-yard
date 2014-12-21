class SessionsControllerBase < ApplicationController
  before_action :load_current_user
  before_action :validate_current_user

  private

  def load_current_user
    @current_user = User.find_by(id: session[:current_user_id])
  end

  def validate_current_user
    if !User.find_by(id: session[:current_user_id])
      session.delete(:current_user_id)

      # Re-direct the user to login again
      redirect_to new_session_path
    end
  end
end

