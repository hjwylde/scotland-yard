require 'rails_helper'

RSpec.describe PlayerTurnPolicy do
  let(:game) { instance_double(Game) }
  let(:active_player) { instance_double(Player) }

  let(:policy) { PlayerTurnPolicy.new(game: game, active_player: active_player) }

  describe '#turn_of?' do
    let(:player) { instance_double(Player) }

    context 'when the game is on-going' do
      before do
        expect(game).to receive(:ongoing?).and_return true
      end

      context 'and the player is the active player' do
        let(:player) { active_player }

        it 'returns true' do
          expect(policy.turn_of?(player)).to be_truthy
        end
      end

      context "and the player isn't the active player" do
        it 'returns false' do
          expect(policy.turn_of?(player)).to be_falsey
        end
      end
    end

    context 'when the game is not on-going' do
      before do
        expect(game).to receive(:ongoing?).and_return false
      end

      it 'returns false' do
        expect(policy.turn_of?(player)).to be_falsey
      end
    end

    context 'when an active player is passed in the constructor' do
      before do
        expect(game).to receive(:ongoing?).and_return true
      end

      it 'uses that player rather than calling the service' do
        expect(GetActivePlayer).to_not receive(:new)

        policy.turn_of?(player)
      end
    end

    context "when an active player isn't passed in the constructor" do
      let(:active_player) { nil }

      before do
        expect(game).to receive(:ongoing?).and_return true
      end

      it 'gets the active player from the service' do
        expect(GetActivePlayer).to receive(:new).and_return double(call: instance_double(Player))

        policy.turn_of?(player)
      end
    end
  end
end

