require 'rails_helper'

RSpec.describe GameFinishedPolicy do
  let(:game) { instance_double(Game) }

  let(:policy) { GameFinishedPolicy.new(game: game) }

  describe '#finished?' do
    context 'when the detectives have won' do
      before do
        expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return(
          instance_double(DetectivesWonPolicy, won?: true))
      end

      it 'returns true' do
        expect(policy.finished?).to be_truthy
      end
    end

    context "when the detectives haven't won" do
      before do
        expect(DetectivesWonPolicy).to receive(:new).with(game: game).and_return(
          instance_double(DetectivesWonPolicy, won?: false))
      end

      context 'and the criminal has won' do
        before do
          expect(CriminalWonPolicy).to receive(:new).with(game: game).and_return(
            instance_double(CriminalWonPolicy, won?: true))
        end

        it 'returns true' do
          expect(policy.finished?).to be_truthy
        end
      end

      context "and the criminal hasn't won" do
        before do
          expect(CriminalWonPolicy).to receive(:new).with(game: game).and_return(
            instance_double(CriminalWonPolicy, won?: false))
        end

        it 'returns false' do
          expect(policy.finished?).to be_falsey
        end
      end
    end
  end
end

