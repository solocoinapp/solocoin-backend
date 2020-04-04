require 'rails_helper'

RSpec.describe 'StaleSessionTerminatorJob' do
  let(:now) { Time.parse('01/01/2020 10:00:00 UTC') }
  before { Timecop.freeze(now) }
  after { Timecop.return }

  context 'when there are outliers' do
    let(:ping_timeout) { Session::PING_TIMEOUT_IN_MINUTES }
    let!(:stale_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago,
                        last_ping_time: (ping_timeout + 1).minutes.ago)
    end
    let!(:another_stale_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago,
                        last_ping_time: (ping_timeout + 5).minutes.ago)
    end
    let!(:valid_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago,
                        last_ping_time: (ping_timeout - 1).minutes.ago)
    end
    let!(:lasped_session) do
      FactoryBot.create(:session, status: 'done', start_time: 1.hour.ago,
                        last_ping_time: (ping_timeout + 1).minutes.ago, end_time: (ping_timeout + 1).minutes.ago)
    end

    it 'should terminate them' do
      StaleSessionTerminatorJob.perform_async

      stale_session.reload
      expect(stale_session.status).to eq('done')
      expect(stale_session.last_ping_time).to eq((ping_timeout + 1).minutes.ago)
      expect(stale_session.end_time).to eq(stale_session.last_ping_time + ping_timeout.minutes)

      another_stale_session.reload
      expect(another_stale_session.status).to eq('done')
      expect(another_stale_session.last_ping_time).to eq((ping_timeout + 5).minutes.ago)
      expect(another_stale_session.end_time).to eq(another_stale_session.last_ping_time + ping_timeout.minutes)

      valid_session.reload
      expect(valid_session.status).to eq('in-progress')
      expect(valid_session.last_ping_time).to eq((ping_timeout - 1).minutes.ago)
      expect(valid_session.end_time).to be_nil

      lasped_session.reload
      expect(lasped_session.status).to eq('done')
      expect(lasped_session.last_ping_time).to eq((ping_timeout + 1).minutes.ago)
      expect(lasped_session.end_time).to eq(lasped_session.last_ping_time)
    end
  end
end
