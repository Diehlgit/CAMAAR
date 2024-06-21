require 'rails_helper'

describe Users::SessionsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "Mostra a tela de login" do
      get :new
      expect(response).to render_template("devise/sessions/new")
    end
  end
end
