require 'rails_helper'

RSpec.describe RoutesController, :type => :controller do
  let(:valid_attributes) { { from_node_id: 1, to_node_id: 2, transport_mode: :taxi } }

  describe 'GET index' do
    it 'assigns all routes as @routes' do
      get :index, {}

      expect(assigns(:routes)).to eq(Route.all)
    end

    it 'serializes them'
  end
end

