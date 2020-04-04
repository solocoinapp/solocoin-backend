require 'rails_helper'

RSpec.describe 'StaleSessionTerminatorJob' do
  let(:now) { Time.parse('01/01/2020 10:00:00 UTC') }
  before { Timecop.freeze(now) }
  after { Timecop.return }

  context 'when there are outliers' do
    let!(:stale_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago, last_ping_time: 11.minutes.ago)
    end
    let!(:another_stale_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago, last_ping_time: 15.minutes.ago)
    end
    let!(:valid_session) do
      FactoryBot.create(:session, status: 'in-progress', start_time: 1.hour.ago, last_ping_time: 9.minutes.ago)
    end
    let!(:lasped_session) do
      FactoryBot.create(:session, status: 'done', start_time: 1.hour.ago, last_ping_time: 11.minutes.ago, end_time: 11.minutes.ago)
    end

    it 'should terminate them' do
      StaleSessionTerminatorJob.perform_async

      expect(stale_session.reload.status).to eq('done')
      expect(stale_session.reload.end_time).to eq(11.minutes.ago + 10.minutes)
      expect(another_stale_session.reload.status).to eq('done')
      expect(another_stale_session.reload.end_time).to eq(15.minutes.ago + 10.minutes)
      expect(valid_session.reload.status).to eq('in-progress')
      expect(valid_session.reload.end_time).to eq(nil)
      expect(lasped_session.reload.status).to eq('done')
      expect(lasped_session.reload.end_time).to eq(11.minutes.ago)
    end
  end
end
