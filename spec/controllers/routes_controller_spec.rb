require 'rails_helper'

RSpec.describe RoutesController, :type => :controller do
  describe 'GET index' do
    let(:routes) { [instance_double(Route)] }

    let(:body) { JSON.parse(response.body) }

    before do
      allow(Route).to receive(:all).and_return routes
    end

    it 'assigns all routes as @routes' do
      xhr :get, :index

      expect(assigns(:routes)).to eq routes
    end

    it 'renders the routes as json' do
      xhr :get, :index

      expect(body).to eq routes.as_json
    end
  end
end

