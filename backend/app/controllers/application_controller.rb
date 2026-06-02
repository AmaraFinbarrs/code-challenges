class ApplicationController < ActionController::API
  # Allows your API controllers to read/write session data
  include ActionController::Cookies
  
  # For Rails 7+, this helper natively restores session access
  include ActionController::Helpers
end
