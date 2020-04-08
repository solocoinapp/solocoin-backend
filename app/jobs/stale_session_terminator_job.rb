class StaleSessionTerminatorJob < ApplicationJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Session.where(status: 'in_progress')
           .where("? - last_ping_time >= INTERVAL '#{Session::PING_TIMEOUT_IN_MINUTES} minutes'", Time.now.utc).each do |session|
      Sessions.end_session(session,
                           auto_terminate: true,
                           end_time: session.last_ping_time + Session::PING_TIMEOUT_IN_MINUTES.minutes)
    end
  end
end
