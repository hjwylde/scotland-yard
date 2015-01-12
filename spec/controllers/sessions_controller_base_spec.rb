require 'rails_helper'

RSpec.describe SessionsControllerBase, :type => :controller do
  describe 'any' do
    let(:current_user_id) { double }
    let(:current_user) { instance_double(User) }

    before do
      allow(session).to receive('[]'.to_sym).with(:current_user_id).and_return current_user_id
      allow(User).to receive(:find_by).with(id: current_user_id).and_return current_user
    end

    it 'assigns the current user as @current_user' do
      expect(assigns(:current_user)).to eq current_user
    end

    context 'when there is no current user' do
      let(:current_user) { nil }

      it 'deletes the current user id from the session' do
        expect(session).to receive(:delete).with(:current_user_id)
      end

      it 'redirects to the login path' do
        expect(response).to redirect_to new_session_path
      end
    end
  end
end

