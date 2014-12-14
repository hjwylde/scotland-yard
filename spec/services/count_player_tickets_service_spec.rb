require 'rails_helper'

RSpec.describe CountPlayerTicketsService do
  let(:player) { instance_double('Player') }

  let(:service) { CountPlayerTicketsService.new(player: player) }

  describe '#call' do
    context 'for a criminal' do
      before do
        expect(player).to receive(:starting_ticket_counts).and_return Criminal::STARTING_TICKET_COUNTS
      end

      context 'in a new game' do
        it "returns #{Criminal::STARTING_TICKET_COUNTS}" do
          expect(service.call).to eq Criminal::STARTING_TICKET_COUNTS
        end
      end

      context 'in an on-going game' do
        it "returns the starting ticket counts minus the used ticket counts plus the detectives' used ticket counts"
      end
    end

    context 'for a detective' do
      before do
        expect(player).to receive(:starting_ticket_counts).and_return Detective::STARTING_TICKET_COUNTS
      end

      context 'in a new game' do
        it "returns #{Detective::STARTING_TICKET_COUNTS}" do
          expect(service.call).to eq Detective::STARTING_TICKET_COUNTS
        end
      end

      context 'in an on-going game' do
        it 'returns the starting ticket counts minus the used ticket counts'
      end
    end
  end
end

