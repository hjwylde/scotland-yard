require 'rails_helper'

RSpec.describe PlayerCanMovePolicy do
  let(:player) { instance_double(Player, id: double) }
  let(:cache) { {} }

  let(:policy) { PlayerCanMovePolicy.new(player: player, cache: cache) }

  describe '#can_move?' do
    let(:game) { instance_double(Game) }

    let(:ticket) { :bus }
    let(:player_ticket_counts) { Hash.new(0).merge({ ticket => 1 }) }
    let(:ticket_counts) { { player.id => player_ticket_counts} }

    before do
      allow(player).to receive(:game).and_return game

      allow(PlayerCanUseTicketPolicy).to receive(:new).with(player: player).and_return(
        instance_double(PlayerCanUseTicketPolicy, can_use?: true))

      allow(CountPlayerTickets).to receive(:new).with(game: game).and_return(
        instance_double(CountPlayerTickets, call: ticket_counts))
    end

    context "when the player can't use any tickets" do
      before do
        expect(PlayerCanUseTicketPolicy).to receive(:new).with(player: player).and_return(
          instance_double(PlayerCanUseTicketPolicy, can_use?: false))
      end

      it 'publishes a fail event' do
        expect { policy.can_move? }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.can_move?).to be_falsey
      end
    end

    context 'when a cache is provided' do
      let(:cache) { { ticket_counts: ticket_counts } }

      it 'uses the cache for the ticket counts' do
        expect(cache).to receive('[]'.to_sym).with(:ticket_counts)

        policy.can_move?
      end

      it "doesn't call the count player tickets service" do
        expect(CountPlayerTickets).to_not receive(:new)

        policy.can_move?
      end
    end

    context "when a cache isn't provided" do
      it 'calls the count player tickets service' do
        expect(CountPlayerTickets).to receive(:new).with(game: game)

        policy.can_move?
      end
    end

    context 'when the checks all pass' do
      it "doesn't publish a fail event" do
        expect { policy.can_move? }.to_not broadcast(:fail)
      end

      it 'returns true' do
        expect(policy.can_move?).to be_truthy
      end
    end
  end
end

