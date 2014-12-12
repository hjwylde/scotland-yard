require 'rails_helper'

RSpec.describe NodesController, :type => :controller do
  describe "GET index" do
    it "assigns all nodes as @nodes" do
      get :index, {}

      expect(assigns(:nodes)).to eq(Node.all)
    end

    it 'serializes them'
  end
end

