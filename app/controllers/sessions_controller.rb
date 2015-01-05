class SessionsController < ApplicationController
  before_action :load_current_user, only: :create
  after_action :save_session, only: :create
  after_action :destroy_session, only: :destroy

  def new
    @user = User.new
  end

  def create
    redirect_to root_path
  end

  def destroy
    redirect_to root_path
  end

  private

  def load_current_user
    @current_user = User.find_by(user_params) || User.create!(user_params)
  end

  def save_session
    session[:current_user_id] = @current_user.try!(:id)
  end

  def destroy_session
    session.delete(:current_user_id)
  end

  def user_params
    params.require(:user).permit(:name)
  end
end

