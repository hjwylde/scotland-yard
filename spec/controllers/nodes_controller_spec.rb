require 'rails_helper'

RSpec.describe NodesController, :type => :controller do
  describe 'GET index' do
    let(:nodes) { [instance_double(Node)] }
    let(:board) { instance_double(Board) }

    let(:body) { JSON.parse(response.body) }

    before do
      allow(Node).to receive(:all).and_return nodes
      allow(Board).to receive(:new).and_return board
    end

    it 'assigns all nodes as @nodes' do
      xhr :get, :index

      expect(assigns(:nodes)).to eq nodes
    end

    it 'loads the board as @board' do
      xhr :get, :index

      expect(assigns(:board)).to eq board
    end

    it 'uses the board to optimise serialization' do
      allow(controller).to receive(:render)
      expect(controller).to receive(:render).with(json: nodes, board: board)

      xhr :get, :index
    end

    it 'renders the nodes as json' do
      xhr :get, :index

      expect(body).to eq nodes.as_json
    end
  end
end

