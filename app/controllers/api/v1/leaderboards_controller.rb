class Api::V1::LeaderboardsController < Api::BaseController
  before_action :set_user, only: :show
  before_action :check_ownership, only: :show

  def show
    response = User.fetch_leaderboard_stats(@user)
    render json: response
  end

  private

  def set_user
    @user = User.find_by!(id: params[:id])
  end

end
