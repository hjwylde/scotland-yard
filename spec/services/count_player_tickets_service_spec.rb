require 'rails_helper'

RSpec.describe CountPlayerTicketsService do
  let(:player) { instance_double('Player') }

  let(:service) { CountPlayerTicketsService.new(player: player) }

  describe '#call' do
    context 'for a criminal' do
      before do
        expect(player).to receive(:starting_tickets_count).and_return Criminal::STARTING_TICKETS_COUNT
      end

      context 'in a new game' do
        it "returns #{Criminal::STARTING_TICKETS_COUNT}" do
          expect(service.call).to eq Criminal::STARTING_TICKETS_COUNT
        end
      end

      context 'in an on-going game' do
        it 'returns the starting tickets count minus the used tickets plus the detectives used tickets'
      end
    end

    context 'for a detective' do
      before do
        expect(player).to receive(:starting_tickets_count).and_return Detective::STARTING_TICKETS_COUNT
      end

      context 'in a new game' do
        it "returns #{Detective::STARTING_TICKETS_COUNT}" do
          expect(service.call).to eq Detective::STARTING_TICKETS_COUNT
        end
      end

      context 'in an on-going game' do
        it 'returns the starting tickets count minus the used tickets'
      end
    end
  end
end

