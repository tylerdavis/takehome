class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  rescue_from StandardError do |exception|

    if exception.class == ActiveRecord::RecordNotFound
      render json: { errors: [exception.message], status: 404, type: 'RecordNotFound' }, status: 404
    else
      render json: { errors: [exception.message], status: 403, type: exception.class.to_s }, status: 403
    end

  end

end
