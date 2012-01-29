require 'spec_helper'
require 'integration/integration_test'

describe "how to use boards" do
  include IntegrationTest

  context "given a valid access token" do
    before :all do
      OAuthPolicy.consumer_credential = OAuthCredential.new @developer_public_key, @developer_secret
      OAuthPolicy.token = OAuthCredential.new @access_token_key, @access_token_secret
      Container.set Trello::Authorization, "AuthPolicy", OAuthPolicy
    end

    it "can add a board" do
      new_board = Board.create(:name => "An example")
      new_board.should_not be_nil
      new_board.id.should_not be_nil
      new_board.name.should == "An example"
      new_board.should_not be_closed
    end

    it "can read the welcome board" do
      welcome_board = Board.find @welcome_board
      welcome_board.name.should === "Welcome Board"
      welcome_board.id.should === @welcome_board
    end

    it "can close a board" do
      new_board = Board.create(:name => "An example")

      Client.put "/boards/#{new_board.id}/closed", { :value => true }
    end
  end
end