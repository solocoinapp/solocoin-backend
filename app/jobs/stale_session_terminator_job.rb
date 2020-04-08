class StaleSessionTerminatorJob < ApplicationJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    Session.where(status: 'in_progress')
           .where("? - last_ping_time >= INTERVAL '#{Session::PING_TIMEOUT_IN_MINUTES} minutes'", Time.now.utc).in_batches do |batch|
      batch.update_all("end_time=last_ping_time + (interval '#{Session::PING_TIMEOUT_IN_MINUTES} minutes'),status=#{Session.statuses['done']}")
    end
  end
end
