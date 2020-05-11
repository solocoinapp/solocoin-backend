class ApplicationController < ActionController::Base
  def health_check
    render json: {}, status: :ok
  end
end
