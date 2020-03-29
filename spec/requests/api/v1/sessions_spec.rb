require 'rails_helper'

RSpec.shared_examples 'done session' do
  let(:in_progress_session) { Session.find(json_response[:id]) }

  it 'sets session status as done' do
    expect(json_response[:status]).to eq('in-progress')
    expect {
      post(endpoint, headers: headers, params: params, as: :json)
      in_progress_session.reload
    }.to change(in_progress_session, :status).from('in-progress').to('done')
  end
end

RSpec.describe 'Sessions' do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) { { Authorization: "Bearer #{user.auth_token}" } }
  let(:endpoint) { '/api/v1/sessions/start' }
  let(:params) { { session: { type: 'home' } } }
  let(:json_response) { response.parsed_body.with_indifferent_access }
  let(:in_progress_session) { Session.find(json_response[:id]) }

  before :example do
    post(endpoint, headers: headers, params: params, as: :json)
  end

  describe 'POST /api/v1/sessions/start' do
    context 'When user is not authenticated' do
      let(:headers) { {} }

      it 'responds with status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    it 'responds with status code 201' do
      expect(response).to have_http_status(201)
    end

    it 'starts session' do
      expect(json_response[:status]).to eq('in-progress')
    end

    context 'When user is at home/isolation' do
      it 'sets user session type as at home' do
        expect(json_response[:session_type]).to eq('home')
      end
    end

    context 'When user is away' do
      let(:params) { { session: { type: 'away' } } }

      it 'sets user session type as away' do
        expect(json_response[:session_type]).to eq('away')
      end
    end

    context 'When ending home session' do
      it_should_behave_like 'done session'

      it 'awards 1 points for every 10 minutes' do
        Timecop.freeze(in_progress_session.start_time + 20.minutes) do
          post(endpoint, headers: headers, params: params, as: :json)
          in_progress_session.reload
          expect(in_progress_session.rewards).to eq(2)
        end
      end
    end

    context 'When ending away session' do
      let(:params) { { session: { type: 'away' } } }

      it_should_behave_like 'done session'

      it 'deducts 10 points for every 10 minutes' do
        Timecop.freeze(in_progress_session.start_time + 30.minutes) do
          post(endpoint, headers: headers, params: params, as: :json)
          in_progress_session.reload
          expect(in_progress_session.rewards).to eq(-30)
        end
      end
    end

    context 'When a user has existing session' do
      it 'is terminated before a new session is created' do
        expect(in_progress_session.status).to eq('in-progress')
        post(endpoint, headers: headers, params: params, as: :json)
        in_progress_session.reload
        expect(in_progress_session.status).to eq('done')
      end
    end

    it 'creates wallet transaction entry' do
      expect {
        post(endpoint, headers: headers, params: params, as: :json)
      }.to change(WalletTransaction, :count)
    end

    it 'updates user wallet_balance' do
      Timecop.freeze(in_progress_session.start_time + 30.minutes) do
        new_balance = user.wallet_balance + 3
        post(endpoint, headers: headers, params: params, as: :json)
        user.reload
        expect(user.wallet_balance.to_s).to eq(new_balance.to_s)
      end
    end
  end
end
