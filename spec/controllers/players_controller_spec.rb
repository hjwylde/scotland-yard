require 'rails_helper'

RSpec.describe PlayersController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Player. As you add validations to Player, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PlayersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all players as @players" do
      player = Player.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:players)).to eq([player])
    end
  end

  describe "GET show" do
    it "assigns the requested player as @player" do
      player = Player.create! valid_attributes
      get :show, {:id => player.to_param}, valid_session
      expect(assigns(:player)).to eq(player)
    end
  end

  describe "GET new" do
    it "assigns a new player as @player" do
      get :new, {}, valid_session
      expect(assigns(:player)).to be_a_new(Player)
    end
  end

  describe "GET edit" do
    it "assigns the requested player as @player" do
      player = Player.create! valid_attributes
      get :edit, {:id => player.to_param}, valid_session
      expect(assigns(:player)).to eq(player)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Player" do
        expect {
          post :create, {:player => valid_attributes}, valid_session
        }.to change(Player, :count).by(1)
      end

      it "assigns a newly created player as @player" do
        post :create, {:player => valid_attributes}, valid_session
        expect(assigns(:player)).to be_a(Player)
        expect(assigns(:player)).to be_persisted
      end

      it "redirects to the created player" do
        post :create, {:player => valid_attributes}, valid_session
        expect(response).to redirect_to(Player.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved player as @player" do
        post :create, {:player => invalid_attributes}, valid_session
        expect(assigns(:player)).to be_a_new(Player)
      end

      it "re-renders the 'new' template" do
        post :create, {:player => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested player" do
        player = Player.create! valid_attributes
        put :update, {:id => player.to_param, :player => new_attributes}, valid_session
        player.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested player as @player" do
        player = Player.create! valid_attributes
        put :update, {:id => player.to_param, :player => valid_attributes}, valid_session
        expect(assigns(:player)).to eq(player)
      end

      it "redirects to the player" do
        player = Player.create! valid_attributes
        put :update, {:id => player.to_param, :player => valid_attributes}, valid_session
        expect(response).to redirect_to(player)
      end
    end

    describe "with invalid params" do
      it "assigns the player as @player" do
        player = Player.create! valid_attributes
        put :update, {:id => player.to_param, :player => invalid_attributes}, valid_session
        expect(assigns(:player)).to eq(player)
      end

      it "re-renders the 'edit' template" do
        player = Player.create! valid_attributes
        put :update, {:id => player.to_param, :player => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested player" do
      player = Player.create! valid_attributes
      expect {
        delete :destroy, {:id => player.to_param}, valid_session
      }.to change(Player, :count).by(-1)
    end

    it "redirects to the players list" do
      player = Player.create! valid_attributes
      delete :destroy, {:id => player.to_param}, valid_session
      expect(response).to redirect_to(players_url)
    end
  end
end

