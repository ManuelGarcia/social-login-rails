require 'rails_helper'

RSpec.describe TokenAuthenticationController, :type => :controller do

  describe "GET sign_in" do
    it "should return success since everything is right" do


      # registering at first...
      provider = "facebook"
      uid = "100003363708252"
      email = "my@email.com"
      user = User.social_registration(provider, uid, email)

      # authenticating with token
      token = 'validtoken'
      email = "my@email.com"

      # Mocking FBGraph
      graph_user_mock = FbGraph::User.new("mock")
      allow(FbGraph::User).to receive_messages(:me => graph_user_mock)
      graph_user_mock_with_identifier = FbGraph::User.new("mock")
      graph_user_mock_with_identifier.identifier = uid
      allow(graph_user_mock).to receive_messages(:fetch => graph_user_mock_with_identifier)

      get :authenticate, { :format => :json, :provider=> provider, :token => token, :email => email }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      #expect(response).to redirect_to(dashboard_index_path)
      #expect(JSON.parse(response.body).length).to eq(3)
      expect(json["status"]).to eq("ok")
      expect(json["user"]["uid"]).to eq(uid)
      expect(json["user"]["email"]).to eq(email)

    end

    it "should register and return success" do

      # registering at first...
      provider = "facebook"
      uid = "100003363708252"
      email = "my@email.com"

      # authenticating with token
      token = 'validtoken'

      # Mocking FBGraph
      graph_user_mock = FbGraph::User.new("mock")
      allow(FbGraph::User).to receive_messages(:me => graph_user_mock)
      graph_user_mock_with_identifier = FbGraph::User.new("mock")
      graph_user_mock_with_identifier.identifier = uid
      allow(graph_user_mock).to receive_messages(:fetch => graph_user_mock_with_identifier)

      get :authenticate, { :format => :json, :provider=> provider, :token => token, :email => email }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      #expect(response).to redirect_to(dashboard_index_path)
      #expect(JSON.parse(response.body).length).to eq(3)
      expect(json["status"]).to eq("ok")
      expect(json["user"]["uid"]).to eq(uid)
      expect(json["user"]["email"]).to eq(email)

    end

    it "should return invalid token, fail" do

      # registering at first...
      provider = "facebook"
      uid = "100003363708252"
      email = "my@email.com"
      user = User.social_registration(provider, uid, email)

      # authenticating with token
      token = 'invalidtoken'
      email = "my@email.com"

      # Mocking FBGraph
      exception_message = "OAuthException :: Invalid OAuth access token."
      allow(FbGraph::User).to receive(:me).and_raise(FbGraph::InvalidToken.new exception_message)


      # Mocking FBGraph
      #FbGraph::User.stub(:me).and_raise(OAuthException)

      get :authenticate, { :format => :json, :provider=> provider, :token => token, :email => '' }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      #expect(response).to redirect_to(dashboard_index_path)
      #expect(JSON.parse(response.body).length).to eq(3)
      expect(json["status"]).to eq("fail")
      expect(json["message"]).to eq(exception_message)

    end
  end

end
