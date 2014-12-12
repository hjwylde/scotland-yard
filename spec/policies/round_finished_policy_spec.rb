require 'rails_helper'

RSpec.describe RoundFinishedPolicy do
  let(:round) { instance_double('Round') }

  let(:policy) { RoundFinishedPolicy.new(round: round) }

  describe '#finished?' do
    let(:game) { instance_double('Game')}

    before do
      allow(round).to receive(:game).and_return game
    end

    context 'when the game has finished' do
      before do
        expect(game).to receive(:finished?).and_return true
      end

      it 'returns true' do
        expect(policy.finished?).to be_truthy
      end
    end

    context "when the game hasn't finished" do
      let(:player) { instance_double('Player') }
      let(:players) { [player] }

      before do
        expect(game).to receive(:finished?).and_return false

        expect(game).to receive(:players).at_least(:once).and_return players
      end

      context 'when there are no players left to move' do
        before do
          expect(round).to receive(:players).and_return players
          expect(PlayerCanMovePolicy).to receive(:new).with(player: player).and_return instance_double('PlayerCanMovePolicy', can_move?: false)
        end

        it 'returns true' do
          expect(policy.finished?).to be_truthy
        end
      end

      context 'when there are some players left to move' do
        before do
          expect(round).to receive(:players).and_return []
        end

        context 'who can move' do
          before do
            expect(PlayerCanMovePolicy).to receive(:new).with(player: player).and_return instance_double('PlayerCanMovePolicy', can_move?: true)
          end

          it 'returns false' do
            expect(policy.finished?).to be_falsey
          end
        end

        context "who can't move" do
          before do
            expect(PlayerCanMovePolicy).to receive(:new).with(player: player).and_return instance_double('PlayerCanMovePolicy', can_move?: false)
          end

          it 'returns true' do
            expect(policy.finished?).to be_truthy
          end
        end
      end
    end
  end
end

