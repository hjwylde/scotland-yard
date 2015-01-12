require 'rails_helper'

RSpec.describe PlayerCanUseTokenPolicy do
  let(:player) { instance_double(Player) }

  let(:policy) { PlayerCanUseTokenPolicy.new(player: player) }

  describe '#can_use?' do
    let(:token) { double }
    let(:count) { 1 }

    context 'when the player has 0 or less tokens' do
      let(:count) { 0 }

      it 'publishes a fail event' do
        expect { policy.can_use?(token: token, count: count) }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.can_use?(token: token, count: count)).to be_falsey
      end
    end

    context 'when the player has some of the token type' do
      it "doesn't publish a fail event" do
        expect { policy.can_use?(token: token, count: count) }.to_not broadcast(:fail)
      end

      it 'returns true' do
        expect(policy.can_use?(token: token, count: count)).to be_truthy
      end
    end
  end
end


