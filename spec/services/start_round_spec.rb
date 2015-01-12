require 'rails_helper'

RSpec.describe StartRound do
  let(:game) { instance_double(Game, finished?: false, initialising?: false) }

  let(:service) { StartRound.new(game: game) }

  describe '#call' do
    let(:current_round) { instance_double(Round, number: Round::STARTING_ROUND_NUMBER) }

    let(:round) { instance_double(Round, save: true) }
    let(:rounds) { double(new: round) }

    before do
      allow(game).to receive(:current_round).and_return current_round
      allow(RoundFinishedPolicy).to receive(:new).and_return double(finished?: true)

      allow(game).to receive(:rounds).and_return rounds
    end

    context 'when the game has finished' do
      before do
        expect(game).to receive(:finished?).and_return true
      end

      it 'publishes a fail event' do
        expect { service.call }.to broadcast(:fail)
      end
    end

    context 'when the current round is on-going' do
      before do
        allow(RoundFinishedPolicy).to receive(:new).and_return double(finished?: false)
      end

      context 'and the override flag is set' do
        it "doesn't publish a fail event" do
          expect { service.call(override_round_finished_policy: true) }.to_not broadcast(:fail)
        end
      end

      context "and the override flag isn't set" do
        it 'publishes a fail event' do
          expect { service.call }.to broadcast(:fail)
        end
      end
    end

    context "when the game hasn't finished and the current round has finished" do
      context 'and the game is currently initialising' do
        let(:current_round) { nil }

        before do
          allow(game).to receive(:initialising?).and_return true
        end

        it 'uses the starting round number for the new round' do
          expect(rounds).to receive(:new).with(number: Round::STARTING_ROUND_NUMBER).and_return round

          service.call
        end
      end

      context "and the game is on-going" do
        it "uses the previous round's number + 1 for the new round" do
          expect(rounds).to receive(:new).with(number: current_round.number + 1).and_return round

          service.call
        end
      end

      context 'and successfully creates and saves a new round' do
        it "doesn't publish a fail event" do
          expect { service.call }.to_not broadcast(:fail)
        end

        it "publishes a success event with the new round" do
          expect { service.call }.to broadcast(:success, round)
        end
      end

      context 'and unsucessfully creates and saves a new round' do
        before do
          expect(round).to receive(:save).and_return false
          expect(round).to receive(:errors).and_return double(full_messages: [double])
        end

        it 'publishes a fail event' do
          expect { service.call }.to broadcast(:fail)
        end
      end
    end
  end
end

