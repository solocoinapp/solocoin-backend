require 'rails_helper'
require 'rake'

RSpec.describe User, type: :model do
  Rails.application.load_tasks
  Rake::Task['generate_random_data:populate_user_table'].invoke

  context 'is in top of leaderboard' do

    let(:user) { User.order('wallet_balance desc').first }

    it 'should exist' do
      expect(user).to be_valid
    end

    let(:user_json) { user.as_json(only: User::LEADERBOARD_FIELDS).merge('wb_rank' => 1) }
    let(:leaderboard_stats) { User.fetch_leaderboard_stats(user) }

    it 'should match leaderboard user data' do
      expect(leaderboard_stats[:user]).to eq(user_json)
    end

    it 'should be leader in leaderboard_stats' do
      expect(leaderboard_stats[:top_users].first).to eq(user_json)
    end

    it 'should see correct no of entries in leaderboard' do
      expect(leaderboard_stats[:top_users].size).to eq(User::LEADERBOARD_LIMIT)
    end
  end

  context 'is not in leaderboard' do

    let(:user) { User.order('wallet_balance desc').last }

    it 'should exist' do
      expect(user).to be_valid
      expect(User.count).to be > User::LEADERBOARD_LIMIT
    end

    let(:user_json) do
      user_rank = User.where('wallet_balance > ?', user.wallet_balance).count + 1
      user.as_json(only: User::LEADERBOARD_FIELDS).merge('wb_rank' => user_rank)
    end

    let(:leaderboard_stats) { User.fetch_leaderboard_stats(user) }

    it 'should match leaderboard user data' do
      expect(leaderboard_stats[:user]).to eq(user_json)
    end

    it 'should see correct no of entries in leaderboard' do
      expect(leaderboard_stats[:top_users].size).to eq(User::LEADERBOARD_LIMIT)
    end
  end

end