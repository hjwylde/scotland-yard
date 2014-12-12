class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def default_serializer_options
    { root: false }
  end
end

