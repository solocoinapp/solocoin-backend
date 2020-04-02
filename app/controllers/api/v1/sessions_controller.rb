class Api::V1::SessionsController < Api::BaseController
  def create
    ensure_one_active_session
    @session = Session.create!(create_params)
    render json: @session, status: :created
  end

  private

  def session_params
    params.require(:session).permit(:type)
  end

  def create_params
    { session_type: session_params[:type],
      user: current_user,
      status: 0,
      start_time: Time.zone.now }
  end

  def ensure_one_active_session
    if current_user.has_active_session?
      Session.transaction do
        session = Sessions.terminate(current_user.active_session)
        after_terminate_session(session)
      end
    end
  end

  def after_terminate_session(session)
    Sessions::Rewards.reward(session)
    Sessions::WalletTransaction.create(session)
    Sessions::Duration.update_user_session_duration(current_user, session)
    Wallet::Transactions.update_user_balance(current_user, session.rewards)
  end
end
