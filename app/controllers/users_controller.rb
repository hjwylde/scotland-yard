class UsersController < SessionsControllerBase
  def show
    render json: @current_user
  end
end

