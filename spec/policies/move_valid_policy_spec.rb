require 'rails_helper'

RSpec.describe MoveValidPolicy do
  let(:player) { instance_double(Player, id: double, current_node_id: 1, detective?: true) }
  let(:to_node) { instance_double(Node, id: 2) }
  let(:ticket) { double }
  let(:token) { nil }
  let(:cache) { {} }

  let(:policy) { MoveValidPolicy.new(player: player, to_node: to_node, ticket: ticket, token: token, cache: cache) }

  before do
    allow(ticket).to receive(:to_sym).and_return ticket
    allow(token).to receive(:to_sym).and_return token
  end

  describe '#valid?' do
    let(:game) { instance_double(Game) }

    let(:criminal) { instance_double(Player, detective?: false, current_node_id: 4) }
    let(:players) { [player, instance_double(Player, detective?: true, current_node_id: 3), criminal] }
    let(:detectives) { players[0...-1] }

    let(:ticket_counts) { { ticket => 1 } }
    let(:player_ticket_counts) { { player.id => ticket_counts } }
    let(:token_counts) { { double_move: 1 } }
    let(:player_token_counts) { { player.id => token_counts } }

    before do
      allow(player).to receive(:game).and_return game
      allow(game).to receive(:players).and_return players
      allow(game).to receive(:detectives).and_return detectives

      allow(PlayerCanUseTicketPolicy).to receive(:new).with(player: player).and_return(
        instance_double(PlayerCanUseTicketPolicy, can_use?: true))

      allow(PlayerCanUseTokenPolicy).to receive(:new).with(player: player).and_return(
        instance_double(PlayerCanUseTokenPolicy, can_use?: true))

      allow(PlayerTurnPolicy).to receive(:new).with(game: game).and_return(
        instance_double(PlayerTurnPolicy, turn_of?: true))

      allow(Route).to receive(:where).with(from_node_id: player.current_node_id,
        to_node_id: to_node.id, transport_mode: ticket).and_return double(exists?: true)

      allow(CountPlayerTickets).to receive(:new).with(game: game).and_return(
        instance_double(CountPlayerTickets, call: player_ticket_counts))
      allow(CountPlayerTokens).to receive(:new).with(game: game).and_return(
        instance_double(CountPlayerTokens, call: player_token_counts))
    end

    context "when the player can't use the ticket" do
      before do
        expect(PlayerCanUseTicketPolicy).to receive(:new).with(player: player).and_return(
          instance_double(PlayerCanUseTicketPolicy, can_use?: false))
      end

      it 'publishes a fail event' do
        expect { policy.valid? }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.valid?).to be_falsey
      end
    end

    context 'if a token is provided' do
      let(:token) { double }

      context "and the player can't use it" do
        before do
          expect(PlayerCanUseTokenPolicy).to receive(:new).with(player: player).and_return(
            instance_double(PlayerCanUseTokenPolicy, can_use?: false))
        end

        it 'publishes a fail event' do
          expect { policy.valid? }.to broadcast(:fail)
        end

        it 'returns false' do
          expect(policy.valid?).to be_falsey
        end
      end
    end

    context "when it's not the player's turn" do
      before do
        expect(PlayerTurnPolicy).to receive(:new).with(game: game).and_return(
          instance_double(PlayerTurnPolicy, turn_of?: false))
      end

      it 'publishes a fail event' do
        expect { policy.valid? }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.valid?).to be_falsey
      end
    end

    context "when a route doesn't exist from the player's node to the given node" do
      before do
        expect(Route).to receive(:where).with(from_node_id: player.current_node_id,
          to_node_id: to_node.id, transport_mode: ticket).and_return double(exists?: false)
      end

      it 'publishes a fail event' do
        expect { policy.valid? }.to broadcast(:fail)
      end

      it 'returns false' do
        expect(policy.valid?).to be_falsey
      end
    end

    context "when the given node is not empty" do
      context 'as a criminal is there' do
        before do
          allow(criminal).to receive(:current_node_id).and_return to_node.id
        end

        it "doesn't publish a fail event" do
          expect { policy.valid? }.to_not broadcast(:fail)
        end

        it 'returns true' do
          expect(policy.valid?).to be_truthy
        end
      end

      context 'as a detective is there' do
        before do
          expect(players[1]).to receive(:current_node_id).and_return to_node.id
        end

        it 'publishes a fail event' do
          expect { policy.valid? }.to broadcast(:fail)
        end

        it 'returns false' do
          expect(policy.valid?).to be_falsey
        end
      end
    end

    context 'when a cache is provided' do
      let(:cache) { { ticket_counts: player_ticket_counts, token_counts: player_token_counts } }

      it 'uses the cache for ticket counts' do
        expect(cache).to receive('[]'.to_sym).with(:ticket_counts)

        policy.valid?
      end

      it 'uses the cache for token counts' do
        expect(cache).to receive('[]'.to_sym).with(:token_counts)

        policy.valid?
      end

      it "doesn't call the count player tickets service" do
        expect(CountPlayerTickets).to_not receive(:new)

        policy.valid?
      end

      it "doesn't call the count player tokens service" do
        expect(CountPlayerTokens).to_not receive(:new)

        policy.valid?
      end
    end

    context "when a cache isn't provided" do
      it 'calls the count player tickets service' do
        expect(CountPlayerTickets).to receive(:new).with(game: game).and_return(
          instance_double(CountPlayerTickets, call: player_ticket_counts))

        policy.valid?
      end

      it 'calls the count player tokens service' do
        expect(CountPlayerTokens).to receive(:new).(game: game).and_return(
          instance_double(CountPlayerTokens, call: player_token_counts))

        policy.valid?
      end
    end

    context 'when the checks all pass' do
      it "doesn't publish a fail event" do
        expect { policy.valid? }.to_not broadcast(:fail)
      end

      it 'returns true' do
        expect(policy.valid?).to be_truthy
      end
    end
  end
end

