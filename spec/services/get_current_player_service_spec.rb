require 'rails_helper'

RSpec.describe GetCurrentPlayerService do
  let(:game) { instance_double('Game') }

  let(:service) { GetCurrentPlayerService.new(game: game) }

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
      4.times do |i|
        let("player#{i}".to_sym) { instance_double('Player') }
      end
      let(:players) { [player0, player1, player2, player3] }
      let(:current_round) { instance_double('Round') }

      let(:policy) { instance_double('PlayerTurnPolicy') }

      before do
        expect(game).to receive(:ongoing?).and_return true

        expect(game).to receive(:current_round).and_return current_round
        expect(PlayerTurnPolicy).to receive(:new).with(round: current_round).and_return policy
        expect(game).to receive(:players).and_return players

        players.each.with_index do |player, index|
          allow(policy).to receive(:turn_of?).with(player).and_return (index - 1 >= 1)
        end
      end

      it 'returns the first player whose turn it is' do
        expect(service.call).to eq player2
      end
    end
  end
end

