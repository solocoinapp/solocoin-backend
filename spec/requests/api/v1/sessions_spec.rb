require 'rails_helper'

RSpec.shared_examples 'no active session' do
  context 'when it is home session' do
    let(:params) { { session: { type: 'home' } } }

    it 'should create new home session' do
      session_count = user.sessions.count
      expect {
        post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
      }.to change { user.sessions.count }.from(session_count).to(session_count + 1)
      json_response = response.parsed_body.with_indifferent_access
      expect(json_response[:status]).to eq('in_progress')
      expect(json_response[:session_type]).to eq('home')
    end
  end

  context 'when it is away session' do
    let(:params) { { session: { type: 'away' } } }

    it 'should create new away session' do
      session_count = user.sessions.count
      expect {
        post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
      }.to change { user.sessions.count }.from(session_count).to(session_count + 1)
      json_response = response.parsed_body.with_indifferent_access
      expect(json_response[:status]).to eq('in_progress')
      expect(json_response[:session_type]).to eq('away')
    end
  end
end

RSpec.describe 'Sessions' do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { { Authorization: "Bearer #{user.auth_token}" } }

  describe 'POST /api/v1/sessions/ping' do
    context 'when is not authenticated' do
      it 'should return 401' do
        post '/api/v1/sessions/ping', params: {}, headers: {}, as: :json
        expect(response).to have_http_status(401)
      end
    end

    context 'when is authenticated' do
      before { Timecop.freeze(now) }
      after { Timecop.return }

      let(:now) { Time.parse('01/01/2020 10:00:00 UTC') }

      context 'when user has an active session' do
        let!(:session) do
          FactoryBot.create(:session, user: user, start_time: now, last_ping_time: now, status: 'in_progress', session_type: 'home')
        end

        it 'should return 202' do
          post '/api/v1/sessions/ping', params: { session: { type: 'home' } }, headers: headers, as: :json
          expect(response).to have_http_status(202)
        end

        context 'when incoming session type is same as active session' do
          let(:params) { { session: { type: 'home' } } }

          it 'should extend last_ping_time correctly' do
            later = now + 5.minutes
            Timecop.freeze(later)

            expect {
              post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
            }.to change { session.reload.last_ping_time }.from(now).to(later)
          end
        end

        context 'when incoming session type is not same as active session' do
          let(:params) { { session: { type: 'away' } } }

          it 'should terminate current session' do
            expect {
              post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
            }.to change { session.reload.status }.from('in_progress').to('done')
          end

          it 'should extend last_ping_time for current session' do
            later = now + 5.minutes
            Timecop.freeze(later)

            expect {
              post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
            }.to change { session.reload.last_ping_time }.from(now).to(later)
          end

          it 'should update end_time for current session' do
            later = now + 5.minutes
            Timecop.freeze(later)

            expect {
              post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
            }.to change { session.reload.end_time }.from(nil).to(later)
          end

          it 'should create new session' do
            post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
            json_response = response.parsed_body.with_indifferent_access
            expect(json_response[:status]).to eq('in_progress')
            expect(json_response[:session_type]).to eq('away')
          end
        end
      end

      context 'when user does not have an active session' do
        let!(:session) do
          FactoryBot.create(:session, user: user, last_ping_time: now, end_time: now, status: 'done')
        end

        it_should_behave_like 'no active session'
      end

      context 'when user does not have any sessions' do
        it_should_behave_like 'no active session'
      end

      context 'When ending home session' do
        let!(:session) do
          FactoryBot.create(:session, user: user, start_time: now, last_ping_time: now, status: 'in_progress', session_type: 'home')
        end
        let!(:params) { { session: { type: 'away' } } }

        it 'awards 1 point for every 10 minutes' do
          Timecop.freeze(session.start_time + 20.minutes)

          expect {
            post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
          }.to change { session.reload.rewards }.from(0).to(2)
        end

        it 'creates wallet transaction entry' do
          expect {
            post('/api/v1/sessions/ping', headers: headers, params: params, as: :json)
          }.to change(WalletTransaction, :count)
        end

        it 'updates user wallet_balance' do
          Timecop.freeze(session.start_time + 30.minutes) do
            new_balance = user.wallet_balance + 3
            post('/api/v1/sessions/ping', headers: headers, params: params, as: :json)
            expect(user.reload.wallet_balance.to_s).to eq(new_balance.to_s)
          end
        end
      end

      context 'When ending away session' do
        let!(:session) do
          FactoryBot.create(:session, user: user, start_time: now, last_ping_time: now, status: 'in_progress', session_type: 'away')
        end
        let(:params) { { session: { type: 'home' } } }

        it 'deducts 10 points for every 10 minutes' do
          Timecop.freeze(session.start_time + 30.minutes)

          expect {
            post '/api/v1/sessions/ping', params: params, headers: headers, as: :json
          }.to change { session.reload.rewards }.from(0).to(-30)
        end
      end

      context 'When there is an error when processing session' do
        let!(:session) do
          FactoryBot.create(:session, user: user, start_time: now, last_ping_time: now, status: 'in_progress', session_type: 'home')
        end

        it 'does not commit any change' do
          expect(session.status).to eq('in_progress')
          allow(Sessions::Rewards).to receive(:calculate).and_raise(TypeError)
          post('/api/v1/sessions/ping', headers: headers, params: { session: { type: 'home' } }, as: :json)
          expect(session.reload.status).to eq('in_progress')
        end
      end
    end
  end
end
