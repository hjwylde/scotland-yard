require 'rails_helper'

RSpec.describe RoundsController, :type => :controller do
  describe 'GET current' do
    let(:current_round) { instance_double(Round) }

    let(:body) { JSON.parse(response.body) }

    before do
      login
      load_game
      load_current_player

      allow(game).to receive(:current_round).and_return current_round
    end

    it 'assigns the current round as @current_round' do
      xhr :get, :current, game_id: game.id

      expect(assigns(:current_round)).to eq current_round
    end

    it 'renders the current round as json' do
      xhr :get, :current, game_id: game.id

      expect(body).to eq current_round.as_json
    end
  end
end

