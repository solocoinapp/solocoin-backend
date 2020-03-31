class Api::V1::LeaderboardsController < Api::BaseController

  def show
    render json: User.fetch_leaderboard_stats(current_user)
  end
end
