module Sessions

  def self.end_session(active_session, end_time: nil, auto_terminate: false)
    Session.transaction do
      terminate(active_session, end_time, auto_terminate)
      after_terminate_session(active_session)
    end
  end

  def self.terminate(active_session, end_time, auto_terminate)
    session_update_params = {status: 1, end_time: end_time || Time.now.utc}
    session_update_params[:last_ping_time] = session_update_params[:end_time] unless auto_terminate
    active_session.update!(session_update_params)
    active_session
  end

  def self.after_terminate_session(session)
    Rewards.reward(session)
    WalletTransaction.create(session)
    Duration.update_user_session_duration(session.user, session)
    ::Wallet::Transactions.update_user_balance(session.user, session.rewards)
  end

  private_class_method :terminate
  private_class_method :after_terminate_session
end
