require 'rails_helper'

RSpec.describe ShowCriminalMovePolicy do
  let(:move) { instance_double(Move) }

  let(:policy) { ShowCriminalMovePolicy.new(move: move) }

  describe '#show?' do
    context 'on the 3rd round' do
      before do
        expect(move).to receive(:round).and_return double(number: 3)
      end

      it 'returns true' do
        expect(policy.show?).to be_truthy
      end
    end

    context 'on the 8th round' do
      before do
        expect(move).to receive(:round).and_return double(number: 3)
      end

      it 'returns true' do
        expect(policy.show?).to be_truthy
      end
    end

    context 'on the 13th round' do
      before do
        expect(move).to receive(:round).and_return double(number: 3)
      end

      it 'returns true' do
        expect(policy.show?).to be_truthy
      end
    end

    context 'on the 18th round' do
      before do
        expect(move).to receive(:round).and_return double(number: 3)
      end

      it 'returns true' do
        expect(policy.show?).to be_truthy
      end
    end

    context 'on any other round' do
      before do
        expect(move).to receive(:round).and_return double(number: 1)
      end

      it 'returns false' do
        expect(policy.show?).to be_falsey
      end
    end
  end
end

