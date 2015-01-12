module SessionsHelper
  attr_reader :current_user

  def login(as: nil)
    @current_user = as || instance_double(User, id: 0)

    allow(User).to receive(:find_by).and_return current_user
  end

  def logout
    @current_user = nil
  end
end

