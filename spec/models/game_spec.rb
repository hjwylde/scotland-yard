require 'rails_helper'

RSpec.describe Game, :type => :model do
  pending 'TODO: Check Game'

  fixtures :games, :players

  describe '#save' do
    let(:game) { Game.create! }

    before do
      (Game::NUMBER_OF_PLAYERS - 1).times do
        game.detectives.create!
      end

      game.criminals.create!
    end

    context "with more than #{Game::NUMBER_OF_PLAYERS} players" do
      before do
        game.detectives.create!
      end

      it 'returns false' do
        expect(game.save).to be_falsey
      end
    end

    context "with #{Game::NUMBER_OF_PLAYERS} #{'player'.pluralize(Game::NUMBER_OF_PLAYERS)}" do
      it 'returns true' do
        expect(game.save).to be_truthy
      end
    end
  end

  describe '#name=' do
    it 'fails'
  end

  describe '#players=' do
    context "with more than #{Game::NUMBER_OF_PLAYERS} players" do
      it 'fails'
    end

    context 'with more than 1 criminal' do
      it 'fails'
    end

    context "with exactly #{Game::NUMBER_OF_PLAYERS} players" do
      it 'persists'
    end

    context 'after the game has started' do
      it 'fails'
    end

    it 'has 1 criminal' do
      expect(games(:ongoing).players.criminals.length).to eq 1
    end
  end

  describe '#detectives' do
    it 'returns the detectives' do
      expect(games(:ongoing).detectives).to match_array games(:ongoing).players.detectives
    end
  end

  describe '#criminals' do
    it 'returns the criminals' do
      expect(games(:ongoing).criminals).to match_array games(:ongoing).players.criminals
    end
  end

  describe '#initialising?' do
    pending 'TODO'
  end

  describe '#started?' do
    context 'with a new game' do
      it 'returns false'
    end

    context 'when the game has at least 1 round' do
      it 'returns true'
    end
  end

  describe '#ongoing?' do
    context 'when the game has started' do
      context 'and finished' do
        before do
          expect(games(:ongoing)).to receive(:finished?).and_return true
        end

        it 'returns false' do
          expect(games(:ongoing).ongoing?).to be_falsey
        end
      end

      context 'and not finished' do
        before do
          expect(games(:ongoing)).to receive(:finished?).and_return false
        end

        it 'returns true' do
          expect(games(:ongoing).ongoing?).to be_truthy
        end
      end
    end

    context "when the game hasn't started" do
      it 'returns false'
    end
  end

  describe '#finished?' do
    context 'when the policy reports finished' do
      before do
        expect(GameFinishedPolicy).to receive(:new).and_return instance_double(GameFinishedPolicy, finished?: true)
      end

      it 'returns true' do
        expect(games(:ongoing).finished?).to be_truthy
      end
    end

    context 'when the policy reports not finished' do
      before do
        expect(GameFinishedPolicy).to receive(:new).and_return instance_double(GameFinishedPolicy, finished?: false)
      end

      it 'returns false' do
        expect(games(:ongoing).finished?).to be_falsey
      end
    end
  end
end

