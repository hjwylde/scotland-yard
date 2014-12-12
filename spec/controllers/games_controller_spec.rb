require 'rails_helper'

RSpec.describe GamesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Game. As you add validations to Game, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GamesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all games as @games" do
      game = Game.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:games)).to eq([game])
    end
  end

  describe "GET show" do
    it "assigns the requested game as @game" do
      game = Game.create! valid_attributes
      get :show, {:id => game.to_param}, valid_session
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "GET new" do
    it "assigns a new game as @game" do
      get :new, {}, valid_session
      expect(assigns(:game)).to be_a_new(Game)
    end
  end

  describe "GET edit" do
    it "assigns the requested game as @game" do
      game = Game.create! valid_attributes
      get :edit, {:id => game.to_param}, valid_session
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Game" do
        expect {
          post :create, {:game => valid_attributes}, valid_session
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create, {:game => valid_attributes}, valid_session
        expect(assigns(:game)).to be_a(Game)
        expect(assigns(:game)).to be_persisted
      end

      it "redirects to the created game" do
        post :create, {:game => valid_attributes}, valid_session
        expect(response).to redirect_to(Game.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        post :create, {:game => invalid_attributes}, valid_session
        expect(assigns(:game)).to be_a_new(Game)
      end

      it "re-renders the 'new' template" do
        post :create, {:game => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested game" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => new_attributes}, valid_session
        game.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested game as @game" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
        expect(assigns(:game)).to eq(game)
      end

      it "redirects to the game" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => valid_attributes}, valid_session
        expect(response).to redirect_to(game)
      end
    end

    describe "with invalid params" do
      it "assigns the game as @game" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => invalid_attributes}, valid_session
        expect(assigns(:game)).to eq(game)
      end

      it "re-renders the 'edit' template" do
        game = Game.create! valid_attributes
        put :update, {:id => game.to_param, :game => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested game" do
      game = Game.create! valid_attributes
      expect {
        delete :destroy, {:id => game.to_param}, valid_session
      }.to change(Game, :count).by(-1)
    end

    it "redirects to the games list" do
      game = Game.create! valid_attributes
      delete :destroy, {:id => game.to_param}, valid_session
      expect(response).to redirect_to(games_url)
    end
  end
end

