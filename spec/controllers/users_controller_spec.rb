require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe 'GET show' do
    let(:body) { JSON.parse(response.body) }

    before do
      login
    end

    it 'renders the current user as json' do
      xhr :get, :show

      expect(body).to eq current_user.as_json
    end
  end
end

