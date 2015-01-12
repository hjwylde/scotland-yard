require 'rails_helper'

RSpec.describe CriminalWonPolicy do
  let(:game) { instance_double(Game) }

  let(:policy) { CriminalWonPolicy.new(game: game) }

  describe '#won?' do
    let(:detectives_won_policy) { instance_double(DetectivesWonPolicy) }

    let(:count_player_tickets) { instance_double(CountPlayerTickets, call: double) }
    let(:player_can_move_policy) { instance_double(PlayerCanMovePolicy, can_move?: false) }
    let(:detectives) { [instance_double(Player), instance_double(Player)] }

    before do
      allow(game).to receive(:started?).and_return true

      allow(DetectivesWonPolicy).to receive(:new).with(game: game).and_return detectives_won_policy
      allow(detectives_won_policy).to receive(:won?).and_return false

      allow(CountPlayerTickets).to receive(:new).with(game: game).and_return count_player_tickets
      allow(PlayerCanMovePolicy).to receive(:new).and_return player_can_move_policy
      allow(game).to receive(:detectives).and_return detectives
    end

    context "when the game hasn't started" do
      before do
        expect(game).to receive(:started?).and_return false
      end

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end

    context "when the detectives have won" do
      before do
        expect(detectives_won_policy).to receive(:won?).and_return true
      end

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end

    context 'when the detectives can move' do
      before do
        expect(player_can_move_policy).to receive(:can_move?).and_return true
      end

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end

    context "when the game has started, the detectives haven't won and the detectives cannot move" do
      before do
        expect(game).to receive(:started?).and_return true
        expect(detectives_won_policy).to receive(:won?).and_return false
      end

      it 'returns true' do
        expect(policy.won?).to be_truthy
      end
    end
  end
end

