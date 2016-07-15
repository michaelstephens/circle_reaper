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
    context "commit message includes [run circle]" do
      it "skips processing request" do
        body = File.read("spec/fixtures/webhook_body_without_run_circle.json")
        expect(CircleReaper::CircleWorker).to_not receive(:perform_in)

        post "/payload", body
      end
    end

    context "commit message does not include [run circle]" do
      it "process's a Github webhook payload" do
        body = File.read("spec/fixtures/webhook_body.json")
        expect(CircleReaper::CircleWorker).to receive(:perform_in)

        post "/payload", body
      end
    end
  end
end
