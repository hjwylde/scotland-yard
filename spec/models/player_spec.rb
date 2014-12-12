require 'rails_helper'

RSpec.describe Player, :type => :model do
  fixtures :games, :players

  describe '#save' do
    context "with a game that has #{Game::NUMBER_OF_PLAYERS} players" do
      it 'fails'
    end

    context "with a game that has less than #{Game::NUMBER_OF_PLAYERS} players" do
      context 'and 1 criminal' do
        context 'when the player is a criminal' do
          it 'fails'
        end
      end
    end
  end

  describe '#game=' do
    it 'fails'
  end

  describe '#name=' do
    it 'fails'
  end

  describe '#type=' do
    it 'fails'
  end

  describe '#origin_node_id' do
    context 'initially' do
      it 'is randomised to an origin node' do
        expect(games(:initialising).detectives.create!.origin_node).to be_in Node.origins
      end
    end
  end

  describe '#origin_node_id=' do
    it 'fails'
  end

  describe '#starting_tickets_count' do
    context 'for a detective' do
      it ''
    end

    context 'for a criminal' do
      it ''
    end
  end

  describe '#detective?' do
    context 'when the player is a detective' do
      it 'returns true' do
        expect(players(:detective0_ongoing).detective?).to be_truthy
      end
    end

    context 'when the player is a criminal' do
      it 'returns false' do
        expect(players(:criminal0_ongoing).detective?).to be_falsey
      end
    end
  end

  describe '#criminal?' do
    context 'when the player is a detective' do
      it 'returns false' do
        expect(players(:detective0_ongoing).criminal?).to be_falsey
      end
    end

    context 'when the player is a criminal' do
      it 'returns true' do
        expect(players(:criminal0_ongoing).criminal?).to be_truthy
      end
    end
  end

  describe '#move_nodes' do
    pending 'TODO'
  end

  describe '#current_node' do
    pending 'TODO'
  end

  describe '#tickets_count' do
    context 'initially' do
      pending 'TODO'
    end

    context 'in an on-going game' do
      context 'for a criminal' do
        it 'returns the starting ticket count minus the used tickets plus the used detective tickets'
      end

      context 'for a detective' do
        it 'returns the starting ticket count minus the used tickets'
      end
    end
  end
end

