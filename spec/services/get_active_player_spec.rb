require 'rails_helper'

RSpec.describe GetActivePlayer do
  let(:game) { instance_double(Game, ongoing?: true) }

  let(:service) { GetActivePlayer.new(game: game) }

  describe '#call' do
    context "when the game isn't on-going" do
      before do
        expect(game).to receive(:ongoing?).and_return false
      end

      it 'returns nil' do
        expect(service.call).to be_nil
      end
    end

    context 'when the game is on-going' do
      let(:ticket_counts) { double }

      let(:moved_player) { instance_double(Player) }
      let(:active_player) { instance_double(Player) }

      before do
        allow(CountPlayerTickets).to receive(:new).and_return double(call: ticket_counts)

        allow(game).to receive(:players).and_return [moved_player, active_player]
        allow(game).to receive(:current_round).and_return double(players: [moved_player])

        allow(PlayerCanMovePolicy).to receive(:new).and_return double(can_move?: true)
      end

      it 'uses a player ticket counts object to optimise database calls' do
        expect(PlayerCanMovePolicy).to receive(:new).with(player: anything, cache: { ticket_counts: ticket_counts })

        service.call
      end

      it 'returns the first player that can move' do
        expect(service.call).to eq active_player
      end
    end
  end
end

