require 'rails_helper'

RSpec.describe GameValidPolicy do
  let(:game) { instance_double(Game) }

  let(:policy) { GameValidPolicy.new(game: game) }

  describe '#valid?' do
    let(:players) { double }

    before do
      allow(game).to receive(:players).and_return players
      allow(players).to receive(:to_a).and_return players
    end

    context "when the game has more than #{Game::NUMBER_OF_PLAYERS} players" do
      let(:players) { double(length: Game::NUMBER_OF_PLAYERS + 1) }

      before do
        allow(players).to receive(:one?).and_return true
      end

      it 'publishes a fail event' do
        expect { policy.valid? }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.valid?).to be_falsey
      end
    end

    context "when the game has less than #{Game::NUMBER_OF_PLAYERS} players" do
      let(:players) { double(length: Game::NUMBER_OF_PLAYERS - 1) }

      context 'and there are less than 2 criminals' do
        before do
          expect(players).to receive(:many?).and_return false
        end

        it "doesn't publish a fail event" do
          expect { policy.valid? }.to_not broadcast(:fail)
        end

        it 'returns true' do
          expect(policy.valid?).to be_truthy
        end
      end

      context 'and there is more than 1 criminal' do
        before do
          expect(players).to receive(:many?).and_return true
        end

        it 'publishes a fail event' do
          expect { policy.valid? }.to broadcast(:fail)
        end

        it 'returns false' do
          expect(policy.valid?).to be_falsey
        end
      end
    end

    context "when the game has exactly #{Game::NUMBER_OF_PLAYERS} players" do
      let(:players) { double(length: Game::NUMBER_OF_PLAYERS) }

      context 'and there is 1 criminal' do
        before do
          expect(players).to receive(:one?).and_return true
        end

        it "doesn't publish a fail event" do
          expect { policy.valid? }.to_not broadcast(:fail)
        end

        it 'returns true' do
          expect(policy.valid?).to be_truthy
        end
      end

      context 'and there are either 0 or more than 1 criminals' do
        before do
          expect(players).to receive(:one?).and_return false
        end

        it 'publishes a fail event' do
          expect { policy.valid? }.to broadcast(:fail)
        end

        it 'returns false' do
          expect(policy.valid?).to be_falsey
        end
      end
    end
  end
end

