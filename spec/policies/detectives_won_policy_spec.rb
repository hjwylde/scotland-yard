require 'rails_helper'

RSpec.describe DetectivesWonPolicy do
  let(:game) { instance_double('Game') }

  let(:policy) { DetectivesWonPolicy.new(game: game) }

  describe '#won?' do
    let(:round) { instance_double('Round') }

    before do
      expect(game).to receive(:rounds).and_return [round]
    end

    context 'when the criminal has lost in one of the rounds' do
      before do
        expect(round).to receive(:criminal_lost?).and_return true
      end

      it 'returns true' do
        expect(policy.won?).to be_truthy
      end
    end

    context 'when the criminal has not lost in any of the rounds' do
      before do
        expect(round).to receive(:criminal_lost?).and_return false
      end

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end
  end
end

