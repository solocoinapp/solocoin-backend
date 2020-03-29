class Api::V1::SessionsController < Api::BaseController
  def start
    ensure_one_active_session
    @session = Session.new(create_params)
    @session.save!
    render json: @session, status: :created
  end

  private

  def session_params
    params.require(:session).permit(:type)
  end

  def create_params
    type = session_params[:type]
    { session_type: type }.merge(user: current_user, status: 0, start_time: Time.zone.now)
  end

  def ensure_one_active_session
    if current_user.has_active_session?
      terminated_session = Sessions.terminate(current_user.active_session)
      after_terminate_session(terminated_session)
    end
  end

  def after_terminate_session(session)
    Sessions::Rewards.reward(session)
    Sessions::WalletTransaction.create(session)
    Wallet::Transactions.update_user_balance(current_user, session.rewards)
  end
end
