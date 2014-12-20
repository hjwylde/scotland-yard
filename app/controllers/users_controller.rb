class UsersController < SessionsControllerBase
  # Don't validate the current user if we're trying to create a new one
  skip_before_action :validate_current_user, only: [:new, :create]

  def show
    render json: @current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      save_session

      redirect_to root_path
    else
      redirect_to new_user_path, alert: @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def save_session
    session[:current_user_id] = @user.id
  end
end

