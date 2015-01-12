require 'rails_helper'

RSpec.describe MakeMove do
  pending 'TODO: Check MakeMove'

  let(:player) { instance_double(Player, game: instance_double(Game, current_round: double)) }
  let(:to_node) { instance_double(Node) }
  let(:ticket) { double }

  let(:service) { MakeMove.new(player: player, to_node: to_node, ticket: ticket) }

  describe '#call' do
    context 'when the player is unable to move' do
      before do
        expect(PlayerCanMovePolicy).to receive(:new).and_return instance_double(PlayerCanMovePolicy, able_to_move?: false)
      end

      it 'publishes a failure event' do
        expect { service.call }.to broadcast(:fail)
      end
    end

    context "when it isn't the player's turn" do
      it 'publishes a failure event'
    end

    context "when the destination node is already taken by another detective" do
      it 'publishes a failure event'
    end

    context "when there is no route from the player's current node to the destination node" do
      it 'publishes a failure event'
    end

    context 'when the move is valid' do
      context 'but the move fails to save' do
        it 'publishes a failure event'
      end

      context 'and the move is persisted' do
        it 'publishes a success event'
      end
    end
  end
end

