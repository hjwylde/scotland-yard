require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  let(:current_user_id) { double }
  let(:current_user) { instance_double(User, id: current_user_id) }

  describe 'GET new' do
    it 'assigns a new user to @user' do
      expect(User).to receive(:new).and_return current_user

      get :new

      expect(assigns(:user)).to eq current_user
    end

    it 'renders :new' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:require_params) { double }
    let(:user_params) { { 'name' => 'any' } }

    before do
      allow(User).to receive(:find_by).with(user_params).and_return current_user

      allow(session).to receive('[]=').with(anything, anything)
    end

    it 'safely loads the user parameters' do
      expect(request.params).to receive(:require).with(:user).and_return require_params
      expect(require_params).to receive(:permit).with(:name).and_return user_params

      post :create, user: user_params
    end

    context 'when the user exists' do
      before do
        expect(User).to receive(:find_by).with(user_params).and_return current_user
      end

      it 'loads the existing user as @current_user' do
        expect(User).to_not receive(:create!)

        post :create, user: user_params

        expect(assigns(:current_user)).to eq current_user
      end
    end

    context "when the user doesn't exist" do
      before do
        expect(User).to receive(:find_by).with(user_params).and_return nil
      end

      it 'creates a new user as @current_user' do
        expect(User).to receive(:create!).with(user_params).and_return current_user

        post :create, user: user_params

        expect(assigns(:current_user)).to eq current_user
      end
    end

    it 'saves the current user to the session' do
      post :create, user: user_params

      expect(session).to have_received('[]=').with(:current_user_id, current_user_id)
    end

    it 'redirects to the root path' do
      post :create, user: user_params

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE destroy' do
    before do
      allow(session).to receive(:delete).with(anything)
    end

    it 'deletes the current user id from the session' do
      xhr :delete, :destroy

      expect(session).to have_received(:delete).with(:current_user_id)
    end

    it 'redirects to the root path' do
      xhr :delete, :destroy

      expect(response).to redirect_to(root_path)
    end
  end
end

