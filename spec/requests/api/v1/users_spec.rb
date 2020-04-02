require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/user/profile' do
    context 'when user is not authenticated' do
      let(:payload) { {} }

      it 'should return 401 response' do
        get profile_api_v1_user_path, as: :json
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
          "wallet_balance" => "0.0",
          "home_duration_in_seconds" => 0,
          "away_duration_in_seconds" => 0
        }
      end

      it 'should be successful' do
        get profile_api_v1_user_path, headers: headers, as: :json
        expect(response.status).to be(200)
      end

      it 'should return the right metadata' do
        get profile_api_v1_user_path, headers: headers, as: :json
        expect(JSON.parse(response.body)).to eq(expected_payload)
      end
    end
  end

  describe 'PATCH /api/v1/user' do
    context 'when user is not authenticated' do
      let(:payload) { {} }

      it 'should return 401 response' do
        patch api_v1_user_path, as: :json
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

      context 'when body is valid' do
        let(:expected_payload) do
          {
            "email" => user.email,
            "id" => user.id,
            "mobile" => user.mobile,
            "name" => user.name,
            "profile_picture_url" => user.profile_picture_url,
            "wallet_balance" => '0.0'
          }
        end
        let(:body) { { user: { name: 'test' } } }

        it 'should be successful' do
          patch api_v1_user_path, params: body, headers: headers, as: :json
          expect(response.status).to be(200)
        end

        it 'should update the user' do
          expect {
            patch api_v1_user_path, params: body, headers: headers, as: :json
          }.to change { user.reload.name }.to('test')
        end
      end

      context 'when body is invalid' do
        let(:body) { { user: { name: 'xx' } } }

        it 'should return unprocessable entity' do
          patch api_v1_user_path, params: body, headers: headers, as: :json
          expect(response.status).to be(422)
        end

        it 'should return the right error response' do
          expected_error_message = {
            "errors" => {
              "name" => [ "is too short (minimum is 3 characters)" ]
            }
          }
          patch api_v1_user_path, params: body, headers: headers, as: :json
          expect(JSON.parse(response.body)).to eq(expected_error_message)
        end
      end
    end
  end
end
