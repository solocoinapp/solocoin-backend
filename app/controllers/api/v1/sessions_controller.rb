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
    pending_referral = Referral.pending.for_candidate(current_user).first
    create_params[:rewards] = pending_referral.reward if pending_referral
    ActiveRecord::Base.transaction do
      @session = Session.create!(create_params)
      pending_referral.rewarded!
    end
  end

  def ensure_one_active_session
    if current_user.has_active_session?
      Sessions.end_session(current_user.active_session)
    end
  end
end
