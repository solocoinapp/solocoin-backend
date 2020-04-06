class Api::V1::SessionsController < Api::BaseController
  def ping
    if current_user.has_active_session? && current_user.active_session.session_type == session_params[:type]
      current_user.active_session.extend_ping
      render json: current_user.active_session, status: :accepted
    else
      session = create_session_for_user
      render json: session, status: :created
    end
  end

  private

  def session_params
    params.require(:session).permit(:type)
  end

  def create_params
    current_time = Time.now.utc
    {
      session_type: session_params[:type],
      user: current_user,
      status: 0,
      start_time: current_time,
      last_ping_time: current_time
    }
  end

  def create_session_for_user
    ensure_one_active_session
    @session = Session.create!(create_params)
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
