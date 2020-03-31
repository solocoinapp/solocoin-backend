require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users/profile' do

    context 'when user is not authenticated' do
      let(:payload) { {} }

      it 'should return 401 response' do
        get api_v1_users_profile_path, as: :json
        expect(response.status).to be(401)
      end
    end

    context 'when user is authenticated' do
      let(:headers) do
        {
          Authorization: "Bearer #{user.auth_token}"
        }
      end

      let(:user) { FactoryBot.create(:user, wallet_balance: 0.0) }
      let(:expected_payload) do
        {
          "email" => user.email,
          "id" => user.id,
          "mobile" => user.mobile,
          "name" => user.name,
          "profile_picture_url" => user.profile_picture_url,
          "wallet_balance" => "0.0"
        }
      end

      it 'should be successful' do
        get api_v1_users_profile_path, headers: headers, as: :json
        expect(response.status).to be(200)
      end

      it 'should return the right metadata' do
        get api_v1_users_profile_path, headers: headers, as: :json
        expect(JSON.parse(response.body)).to eq(expected_payload)
      end
    end
  end
end
