require 'rails_helper'

RSpec.describe PlayersController, :type => :controller do
  describe 'GET index' do
    let(:ticket_counts) { double }
    let(:token_counts) { double }

    let(:body) { JSON.parse(response.body) }

    before do
      login
      load_game
      load_current_player

      allow(CountPlayerTickets).to receive(:new).and_return double(call: ticket_counts)
      allow(CountPlayerTokens).to receive(:new).and_return double(call: token_counts)
    end

    it 'assigns all players as @players' do
      xhr :get, :index, game_id: game.id

      expect(assigns(:players)).to eq game.players
    end

    it 'assigns the ticket counts as @ticket_counts' do
      xhr :get, :index, game_id: game.id

      expect(assigns(:ticket_counts)).to eq ticket_counts
    end

    it 'assigns the token counts as @ticket_counts' do
      xhr :get, :index, game_id: game.id

      expect(assigns(:token_counts)).to eq token_counts
    end

    it 'uses the ticket and token counts to optimise serialization' do
      allow(controller).to receive(:render)
      expect(controller).to receive(:render).with(json: game.players,
        current_player: current_player, ticket_counts: ticket_counts, token_counts: token_counts)

      xhr :get, :index, game_id: game.id
    end

    it 'renders the players as json' do
      xhr :get, :index, game_id: game.id

      expect(body).to eq game.players.as_json
    end
  end

  describe 'GET active' do
    let(:active_player) { instance_double(Player, id: 1) }

    let(:body) { JSON.parse(response.body) }

    before do
      login
      load_game
      load_current_player

      allow(GetActivePlayer).to receive(:new).and_return double(call: active_player)
    end

    it 'assigns the active player as @active_player' do
      xhr :get, :active, game_id: game.id

      expect(assigns(:active_player)).to eq active_player.as_json
    end

    it 'renders the active player as json' do
      xhr :get, :active, game_id: game.id

      expect(body).to eq active_player.as_json
    end
  end

  describe 'POST create' do
    it 'safely loads the player parameters' do
      pending
    end

    context 'when the create player service fails' do
      it 'has an bad request status' do
        expect(response).to have_http_status :bad_request
      end
    end

    context 'when the create player service succeeds' do
      it 'assigns the new player to @player' do
        expect(assigns(:player)).to eq player
      end
    end

    it 'redirects to the game' do
      expect(response).to redirect_to game
    end
  end
end

