require 'rails_helper'

RSpec.describe DetectivesWonPolicy do
  let(:game) { instance_double(Game) }

  let(:policy) { DetectivesWonPolicy.new(game: game) }

  describe '#won?' do
    before do
      expect(game).to receive(:current_round).and_return current_round
    end

    context "when the game hasn't started" do
      let(:current_round) { nil }

      it 'returns false' do
        expect(policy.won?).to be_falsey
      end
    end

    context 'when the game has started' do
      let(:current_round) { instance_double(Round) }

      context "and the criminal hasn't moved" do
        before do
          expect(current_round).to receive(:moves).and_return double(of_criminals: [])
        end

        it 'returns false' do
          expect(policy.won?).to be_falsey
        end
      end

      context 'and the criminal has moved' do
        let(:detective_node_ids) { [double, double, double] }
        let(:criminal_node_id) { double }
        let(:detective_moves) { detective_node_ids.map { |node_id| double(pluck: node_id) } }

        before do
          expect(current_round).to receive(:moves).at_least(:once).and_return double(of_criminals:
            [double(to_node_id: criminal_node_id)], of_detectives: double(pluck: detective_moves))
          expect(current_round).to receive(:previous).at_least(:once).and_return double(moves:
            double(of_detectives: double(pluck: [])))
        end

        context 'and the detectives share a square with the criminal' do
          let(:criminal_node_id) { detective_node_ids[0] }

          it 'returns true' do
            expect(policy.won?).to be_truthy
          end
        end

        context "and the detectives don't share a square with the criminal" do
          it 'returns false' do
            expect(policy.won?).to be_falsey
          end
        end
      end
    end
  end
end

