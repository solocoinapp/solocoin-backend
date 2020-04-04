require 'rails_helper'

RSpec.describe 'Callbacks', type: :request do
  describe 'user login' do
    context 'with valid firebase token' do
      let(:params) do
        {
          user: {
            id_token: '123',
            country_code: '+44',
            mobile: user.mobile,
            uid: 'test'
          }
        }
      end
      let(:firebase_body) do
        {
          users: [
            phoneNumber: "+44#{user.mobile}"
          ]
        }
      end

      before do
        stub_request(:post, "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=").
          with(body: "idToken=123").
          to_return(status: 200,
                    body: firebase_body.to_json,
                    headers: {'Content-Type' => 'application/json'})
      end

      context 'when user exists' do
        let(:user) { FactoryBot.create(:user) }
        let(:expected_response) do
          {
            'id' => user.id,
            'auth_token' => user.auth_token
          }
        end

        it 'should return the user' do
          post mobile_login_api_v1_callbacks_path, params: params, as: :json
          expect(response.status).to be(200)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'when user does not exist' do
        let(:params) do
          {
            user: {
              id_token: '123',
              country_code: '+44',
              mobile: '1111111111',
              uid: 'test'
            }
          }
        end
        let(:firebase_body) do
          {
            users: [
              phoneNumber: "+441111111111"
            ]
          }
        end

        it 'should return unauthorised' do
          post mobile_login_api_v1_callbacks_path, params: params, as: :json
          expect(response.status).to be(401)
        end
      end
    end

    context 'with invalid firebase token' do
      let(:params) do
        {
          user: {
            id_token: 'missing',
            country_code: '+44',
            mobile: '1234567890',
            uid: 'test'
          }
        }
      end

      before do
        stub_request(:post, "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=").
          with(body: "idToken=missing").
          to_return(status: 404,
                    body: "{}",
                    headers: {'Content-Type' => 'application/json'})
      end

      it 'should return unauthorised' do
        post mobile_login_api_v1_callbacks_path, params: params, as: :json
        expect(response.status).to be(401)
      end
    end
  end

  describe 'user signup' do
    context 'with a valid firebase token' do
      let(:params) do
        {
          user: {
            id_token: '123',
            country_code: '+44',
            mobile: user.mobile,
            uid: 'test',
            name: user.name
          }
        }
      end
      let(:firebase_body) do
        {
          users: [
            phoneNumber: "+44#{user.mobile}"
          ]
        }
      end

      before do
        stub_request(:post, "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=").
          with(body: "idToken=123").
          to_return(status: 200,
                    body: firebase_body.to_json,
                    headers: {'Content-Type' => 'application/json'})
      end

      context 'when user exists' do
        let(:user) { FactoryBot.create(:user) }

        it 'should update user identities' do
          expect {
            post mobile_sign_up_api_v1_callbacks_path, params: params, as: :json
          }.to change { user.identities.count }.by(1)
        end
      end

      context 'when user does not exist' do
        let(:user) { FactoryBot.build(:user) }

        it 'should create a new user' do
          expect {
            post mobile_sign_up_api_v1_callbacks_path, params: params, as: :json
          }.to change { User.count }.by(1)
        end
      end

      context 'when params are invalid' do
        let(:user) { FactoryBot.build(:user, name: '') }

        it 'should return 422' do
          post mobile_sign_up_api_v1_callbacks_path, params: params, as: :json
          expect(response.status).to be(422)
          expect(JSON.parse(response.body)).to eq({
            'error' => 'Validation failed',
            'errors' => {
              'name' => [ 'can\'t be blank', 'is too short (minimum is 3 characters)' ]
            }
          })
        end
      end
    end

    context 'with an invalid firebase token' do
      let(:params) do
        {
          user: {
            id_token: 'missing',
            country_code: '+44',
            mobile: '1234567890',
            uid: 'test'
          }
        }
      end

      before do
        stub_request(:post, "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=").
          with(body: "idToken=missing").
          to_return(status: 404,
                    body: "{}",
                    headers: {'Content-Type' => 'application/json'})
      end

      it 'should return 422' do
        post mobile_sign_up_api_v1_callbacks_path, params: params, as: :json
        expect(response.status).to be(422)
      end
    end

    context 'with an firebase token missing' do
      let(:params) do
        {
          user: {
            country_code: '+44',
            mobile: '1234567890',
            uid: 'test',
            name: 'new name'
          }
        }
      end

      it 'should return bad request' do
        post mobile_sign_up_api_v1_callbacks_path, params: params, as: :json
        expect(response.status).to be(400)
      end
    end
  end
end
