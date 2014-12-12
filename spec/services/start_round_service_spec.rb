require 'rails_helper'

RSpec.describe StartRoundService do
  let(:game) { instance_double('Game') }

  let(:service) { StartRoundService.new(game: game) }

  describe '#call' do
    let(:rounds) { double }
    let(:round) { instance_double('Round') }

    before do
      allow(game).to receive(:rounds).and_return rounds
      allow(rounds).to receive(:new).and_return round
    end

    context 'when the game has finished' do
      before do
        expect(game).to receive(:finished?).and_return true
      end

      it 'publishes a failure event' do
        expect { service.call }.to broadcast(:fail)
      end
    end

    context 'when the game is on-going' do
      let(:current_round) { double(number: 5) }

      before do
        expect(game).to receive(:finished?).and_return false

        expect(game).to receive(:current_round).at_least(:once).and_return current_round
      end

      context 'and the current round is on-going' do
        before do
          expect(current_round).to receive(:ongoing?).and_return true
        end

        it 'publishes a failure event' do
          expect { service.call }.to broadcast(:fail)
        end
      end

      context 'and the current round has finished' do
        before do
          expect(current_round).to receive(:ongoing?).and_return false
          expect(game).to receive(:initialising?).and_return false
        end

        it "uses the previous round's number plus 1 as the round number" do
          expect(rounds).to receive(:new).with(number: current_round.number + 1).and_return round

          allow(round).to receive(:save).and_return true

          service.call
        end

        context 'but save fails' do
          before do
            expect(round).to receive(:save).and_return false
            expect(round).to receive(:errors).and_return double(full_messages: double)
          end

          it 'publishes a failure event' do
            expect { service.call }.to broadcast(:fail)
          end
        end

        context 'and save succeeds' do
          before do
            expect(round).to receive(:save).and_return true
          end

          it 'publishes a success event' do
            expect { service.call }.to broadcast(:success)
          end
        end
      end
    end

    context 'when the game is initialising' do
      before do
        expect(game).to receive(:finished?).and_return false
        expect(game).to receive(:current_round).and_return nil

        expect(game).to receive(:initialising?).and_return true
      end

      it "uses #{Round::STARTING_ROUND_NUMBER} as the round number" do
        expect(rounds).to receive(:new).with(number: Round::STARTING_ROUND_NUMBER).and_return round

        allow(round).to receive(:save).and_return true

        service.call
      end

      context 'and save fails' do
        before do
          expect(round).to receive(:save).and_return false
          expect(round).to receive(:errors).and_return double(full_messages: double)
        end

        it 'publishes a failure event' do
          expect { service.call }.to broadcast(:fail)
        end
      end

      context 'and save succeeds' do
        before do
          expect(round).to receive(:save).and_return true
        end

        it 'publishes a success event' do
          expect { service.call }.to broadcast(:success)
        end
      end
    end
  end
end

