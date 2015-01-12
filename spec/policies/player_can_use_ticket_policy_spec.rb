require 'rails_helper'

RSpec.describe PlayerCanUseTicketPolicy do
  let(:player) { instance_double(Player) }

  let(:policy) { PlayerCanUseTicketPolicy.new(player: player) }

  describe '#can_use?' do
    let(:ticket) { double }
    let(:count) { 1 }

    let(:supported_transport_modes) { [ticket] }

    before do
      allow(player).to receive(:current_node).and_return double(transport_modes: supported_transport_modes)
    end

    context 'when the player has 0 or less tickets' do
      let(:count) { 0 }

      it 'publishes a fail event' do
        expect { policy.can_use?(ticket: ticket, count: count) }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.can_use?(ticket: ticket, count: count)).to be_falsey
      end
    end

    context "when the current node doesn't support the ticket type" do
      let(:supported_transport_modes) { [] }

      it 'publishes a fail event' do
        expect { policy.can_use?(ticket: ticket, count: count) }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.can_use?(ticket: ticket, count: count)).to be_falsey
      end
    end

    context 'when the player has some of the ticket type and their node supports it' do
      it "doesn't publish a fail event" do
        expect { policy.can_use?(ticket: ticket, count: count) }.to_not broadcast(:fail)
      end

      it 'returns true' do
        expect(policy.can_use?(ticket: ticket, count: count)).to be_truthy
      end
    end
  end
end

