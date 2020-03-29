require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST /api/v1/sessions/start' do
    it 'starts session'
    it 'marks session status to in-progress'

    context 'When user is at home/isolation' do
      it 'sets user session type as at home'
    end

    context 'When user is away' do
      it 'sets user session type as away'
    end

    context 'When ending home session' do
      it 'sets session status as done'
      it 'awards 1 points for every 10 minutes'
    end

    context 'When ending away session' do
      it 'sets session status as done'
      it 'deducts 10 points for every 10 minutes'
    end

    context 'When a user has existing session' do
      it 'is terminated before a new session is created'
    end
  end
end
