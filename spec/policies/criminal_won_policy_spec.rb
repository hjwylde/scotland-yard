require 'rails_helper'

RSpec.describe CriminalWonPolicy do
  let(:game) { instance_double('Game') }

  let(:policy) { CriminalWonPolicy.new(game: game) }

  describe '#won?' do
    context 'when the detectives have lost' do
      before do
        expect(DetectivesLostPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesLostPolicy', lost?: true)
      end

      it 'returns true' do
        expect(policy.won?).to be_truthy
      end
    end

    context 'when the detectives have won' do
      before do
        expect(DetectivesLostPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesLostPolicy', lost?: false)
      end

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end
  end
end

