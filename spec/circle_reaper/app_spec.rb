require "rack/test"

RSpec.describe CircleReaper::App do
  include Rack::Test::Methods

  def app
    CircleReaper::App
  end

  describe "GET /" do
    it "says hello" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  describe "POST /payload" do
    context "comment body includes pipfitter" do
      it "process's a Github webhook payload" do
        body = File.read("spec/fixtures/webhook_body.json")
        expect(CircleReaper::CircleWorker).to receive(:perform_async)

        post "/payload", body
      end
    end

    context "comment body does not include pipfitter" do
      it "skips processing request" do
        body = File.read("spec/fixtures/webhook_body_without_pipefitter.json")
        expect(CircleReaper::CircleWorker).to_not receive(:perform_async)

        post "/payload", body
      end
    end
  end
end
