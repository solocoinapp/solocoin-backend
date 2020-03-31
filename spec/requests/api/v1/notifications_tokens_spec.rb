require 'rails_helper'

RSpec.describe 'NotificationTokens', type: :request do
  describe 'POST /api/v1/notification_tokens' do
    context 'when user is not authenticated' do
      let(:payload) { {} }

      it 'should return 401 response' do
        post api_v1_notification_tokens_path, as: :json
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
      let(:body) do
        { notification: { token: 'new_token' } }
      end

      context 'when user does not have a notifications token' do
        before { user.notification_tokens.delete_all }

        it 'should return created' do
          post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          expect(response.status).to be(201)
        end

        it 'should create notifications token for the user' do
          expect {
            post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          }.to change { user.notification_tokens.count }.by (1)
        end
      end

      context 'when user already has a notifications token' do
        before do
          user.notification_tokens << NotificationToken.new(value: 'token')
        end

        let(:body) do
          { notification: { token: 'token' } }
        end

        it 'should return created' do
          post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          expect(response.status).to be(201)
        end

        it 'should not create a new notifications token for the user' do
          expect {
            post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          }.to_not change { user.notification_tokens.count }
        end
      end

      context 'when creation is invalid' do
        let(:body) do
          { notification: { token: '' } }
        end

        it 'should return unprocessable entity' do
          post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          expect(response.status).to be(422)
        end

        it 'should return the right error message' do
          expected_error_message = {
            "error" => "Value can't be blank",
            "errors" => []
          }
          post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          expect(JSON.parse(response.body)).to eq(expected_error_message)
        end

        it 'should not create a new token' do
          expect {
            post api_v1_notification_tokens_path, params: body, headers: headers, as: :json
          }.to_not change { user.notification_tokens.count }
        end
      end
    end
  end
end
