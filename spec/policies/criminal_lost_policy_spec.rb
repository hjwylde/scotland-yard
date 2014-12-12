require 'rails_helper'

RSpec.describe CriminalLostPolicy do
  let(:game) { instance_double('Game') }

  let(:policy) { CriminalLostPolicy.new(game: game) }

  describe '#lost?' do
    context 'when the detectives have won' do
      before do
        expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesWonPolicy', won?: true)
      end

      it 'returns true' do
        expect(policy.lost?).to be_truthy
      end
    end

    context 'when the detectives have lost' do
      before do
        expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return instance_double('DetectivesWonPolicy', won?: false)
      end

      it 'returns false' do
        expect(policy.lost?).to be_falsey
      end
    end
  end
end

