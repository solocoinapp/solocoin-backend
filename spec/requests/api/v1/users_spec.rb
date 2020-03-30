require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /api/v1/users/:id' do
    before do
      get api_v1_user_path(user_id), headers: headers, as: :json
    end
    let(:user_id) { 1 }

    context 'when user is not authenticated' do
      let(:headers) { {} }

      it 'should return 401 response' do
        expect(response.status).to be(401)
      end
    end

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:headers) do
        { Authorization: "Bearer #{user.auth_token}" }
      end

      context 'when user does not exist' do
        let(:user_id) { -1 }

        it 'should return 404 response' do
          expect(response.status).to be(404)
        end
      end

      context 'when user exists' do
        let(:expected_response) do
          {
            "user" => {
              "email" => user.email,
              "id" => user.id,
              "mobile" => user.mobile,
              "name" => user.name,
              "profile_picture_url" => user.profile_picture_url,
              "wallet_balance" => user.wallet_balance.to_f.to_s
            }
          }
        end
        let(:user_id) { user.id }

        it 'should return the right user metadata' do
          expect(JSON.parse(response.body)).to eql(expected_response)
        end
      end
    end
  end
end
