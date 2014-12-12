require 'rails_helper'

RSpec.describe DetectivesLostPolicy do
  let(:game) { instance_double('Game') }

  let (:policy) { DetectivesLostPolicy.new(game: game) }

  describe '#lost?' do
    context "when the game hasn't started" do
      before do
        expect(game).to receive(:started?).and_return false
      end

      it 'returns false' do
        expect(policy.lost?).to be_falsey
      end
    end

    context 'when the game has started' do
      before do
        expect(game).to receive(:started?).and_return true
      end

      context 'and the detectives have won' do
        before do
          expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesWonPolicy', won?: true)
        end

        it 'returns false' do
          expect(policy.lost?).to be_falsey
        end
      end

      context "and the detectives haven't won" do
        let(:detectives) { [instance_double('Detective')] }
        let(:player_can_move_policy) { instance_double('PlayerCanMovePolicy') }

        before do
          expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesWonPolicy', won?: false)

          expect(game).to receive(:detectives).and_return detectives
          expect(PlayerCanMovePolicy).to receive(:new).and_return player_can_move_policy
        end

        context "while none of them can move" do
          before do
            expect(player_can_move_policy).to receive(:can_move?).and_return false
          end

          it 'returns true' do
            expect(policy.lost?).to be_truthy
          end
        end

        context 'while some of them can move' do
          before do
            expect(player_can_move_policy).to receive(:can_move?).and_return true
          end

          it 'returns false' do
            expect(policy.lost?).to be_falsey
          end
        end
      end
    end
  end
end

