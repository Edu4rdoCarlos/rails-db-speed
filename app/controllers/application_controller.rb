class ApplicationController < ActionController::Base
  # Desabilitar proteção CSRF para API
  skip_before_action :verify_authenticity_token
end 