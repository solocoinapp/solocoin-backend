require 'rails_helper'

RSpec.describe 'LeaderBoard', type: :request do
  describe 'GET /api/v1/leader_board' do
    context 'when user is not authenticated' do
      let(:payload) { {} }

      it 'should return 401 response' do
        get api_v1_leaderboard_path, as: :json
        expect(response.status).to be(401)
      end
    end

    context 'when user is authenticated' do
      let(:headers) do
        {
          Authorization: "Bearer #{user.auth_token}"
        }
      end

      let!(:users) do
        (1..4).map do |i|
          FactoryBot.create(:user, name: "User##{i}", wallet_balance: i * 10)
        end
      end

      context 'when user is in the top list' do
        let(:user) { FactoryBot.create(:user, wallet_balance: 35.0) }
        let(:expected_response) do
          {
            'top_users' => [
              {
                'country_code' => nil,
                'id' => users[3].id,
                'name' => users[3].name,
                'wallet_balance' => '40.0',
                'wb_rank' => 1
              },
              {
                'country_code' => nil,
                'id' => user.id,
                'name' => user.name,
                'wallet_balance' => '35.0',
                'wb_rank' => 2
              },
              {
                'country_code' => nil,
                'id' => users[2].id,
                'name' => users[2].name,
                'wallet_balance' => '30.0',
                'wb_rank' => 3
              }
            ],
            'user' => {
              'country_code' => nil,
              'id' => user.id,
              'name' => user.name,
              'wallet_balance' => '35.0',
              'wb_rank'=> 2
            }
          }
        end

        it 'should return the right list and the right user rank' do
          stub_const("LeaderBoard", LeaderBoard, transfer_nested_constants: true)
          stub_const("LeaderBoard::LIMIT", 3)
          get api_v1_leaderboard_path, headers: headers, as: :json

          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'when user is not the top list' do
        let(:expected_response) do
          {
            'top_users' => users[1..-1].reverse.map.each_with_index do |u, i|
              {
                'country_code' => nil,
                'id' => u.id,
                'name' => u.name,
                'wallet_balance' => u.wallet_balance.to_f.to_s,
                'wb_rank' => i + 1
              }
            end,
            'user' => {
              'country_code' => nil,
              'id' => user.id,
              'name' => user.name,
              'wallet_balance' => '0.0',
              'wb_rank'=> 5
            }
          }
        end
        let(:user) { FactoryBot.create(:user, wallet_balance: 0.0) }

        it 'should return the right list and the right user rank' do
          stub_const("LeaderBoard", LeaderBoard, transfer_nested_constants: true)
          stub_const("LeaderBoard::LIMIT", 3)
          get api_v1_leaderboard_path, headers: headers, as: :json

          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end
  end
end
