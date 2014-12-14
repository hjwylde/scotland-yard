require 'rails_helper'

RSpec.describe PlayerCanUseTicketPolicy do
  let(:player) { instance_double('Player') }
  ticket = :taxi

  let(:policy) { PlayerCanUseTicketPolicy.new(player: player) }

  describe '#can_use?' do
    context "when the player has no #{ticket} tickets" do
      before do
        expect(player).to receive(:ticket_counts).and_return({ ticket => 0 })
      end

      it 'returns false' do
        expect(policy.can_use?(ticket: ticket)).to be_falsey
      end
    end

    context "when the player has some #{ticket} tickets" do
      before do
        expect(player).to receive(:ticket_counts).and_return({ ticket => 1 })
      end

      context "but the player's current node doesn't support #{ticket} tickets" do
        before do
          expect(player).to receive(:current_node).and_return instance_double('Node', transport_modes: [])
        end

        it 'returns false' do
          expect(policy.can_use?(ticket: ticket)).to be_falsey
        end
      end

      context "and the player's current node supports #{ticket} tickets" do
        before do
          expect(player).to receive(:current_node).and_return instance_double('Node', transport_modes: [ticket.to_s])
        end

        it 'returns true' do
          expect(policy.can_use?(ticket: ticket)).to be_truthy
        end
      end
    end
  end
end

