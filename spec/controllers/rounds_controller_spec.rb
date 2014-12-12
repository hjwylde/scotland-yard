require 'rails_helper'

RSpec.describe RoundsController, :type => :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Round" do
        expect {
          post :create, {:round => valid_attributes}, valid_session
        }.to change(Round, :count).by(1)
      end

      it "assigns a newly created round as @round" do
        post :create, {:round => valid_attributes}, valid_session
        expect(assigns(:round)).to be_a(Round)
        expect(assigns(:round)).to be_persisted
      end

      it "redirects to the created round" do
        post :create, {:round => valid_attributes}, valid_session
        expect(response).to redirect_to(Round.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved round as @round" do
        post :create, {:round => invalid_attributes}, valid_session
        expect(assigns(:round)).to be_a_new(Round)
      end

      it "re-renders the 'new' template" do
        post :create, {:round => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end

