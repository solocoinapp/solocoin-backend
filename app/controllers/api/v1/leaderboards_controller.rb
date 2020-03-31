class Api::V1::LeaderboardsController < Api::BaseController
  def show
    render json: LeaderBoard.new(user: current_user)
  end
end
