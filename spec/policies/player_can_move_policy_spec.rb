require 'rails_helper'

RSpec.describe PlayerCanMovePolicy do
  let(:player) { instance_double('Player') }

  let(:policy) { PlayerCanMovePolicy.new(player: player) }

  describe '#can_move?' do
    let(:ticket_policy) { instance_double('PlayerCanUseTicketPolicy') }

    before do
      expect(PlayerCanUseTicketPolicy).to receive(:new).and_return ticket_policy
      allow(ticket_policy).to receive(:can_use?).and_return false
    end

    context 'if the player may use a taxi ticket' do
      before do
        expect(ticket_policy).to receive(:can_use?).with(ticket: :taxi).and_return true
      end

      it 'returns true' do
        expect(policy.can_move?).to be_truthy
      end
    end

    context 'if the player may use a bus ticket' do
      before do
        expect(ticket_policy).to receive(:can_use?).with(ticket: :bus).and_return true
      end

      it 'returns true' do
        expect(policy.can_move?).to be_truthy
      end
    end

    context 'if the player may use an underground ticket' do
      before do
        expect(ticket_policy).to receive(:can_use?).with(ticket: :underground).and_return true
      end

      it 'returns true' do
        expect(policy.can_move?).to be_truthy
      end
    end

    context 'if the player may use a black ticket' do
      before do
        expect(ticket_policy).to receive(:can_use?).with(ticket: :black).and_return true
      end

      it 'returns true' do
        expect(policy.can_move?).to be_truthy
      end
    end

    context 'if the player cannot use any ticket' do
      it 'returns false' do
        expect(policy.can_move?).to be_falsey
      end
    end
  end
end

