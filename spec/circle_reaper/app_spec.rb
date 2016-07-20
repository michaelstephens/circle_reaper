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

    context "secret token is set" do
      it "verifies signature of the request" do
        body = File.read("spec/fixtures/webhook_body.json")

        secret_token = "some-token"
        ENV["SECRET_TOKEN"] = secret_token

        digest = OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new("sha1"),
          secret_token,
          body
        )

        allow(CircleReaper::CircleWorker).to receive(:perform_in)

        post "/payload", body, { "HTTP_X_HUB_SIGNATURE" => "sha1=#{digest}" }

        expect(last_response).to be_ok

        ENV["SECRET_TOKEN"] = nil
      end

      it "returns 500 with 'Signatures didn't match' when verification fails" do
        body = File.read("spec/fixtures/webhook_body.json")

        secret_token = "some-token"
        ENV["SECRET_TOKEN"] = secret_token

        allow(CircleReaper::CircleWorker).to receive(:perform_in)

        post "/payload", body, { "HTTP_X_HUB_SIGNATURE" => "sha1=fake-digest" }

        expect(last_response).to be_server_error

        ENV["SECRET_TOKEN"] = nil
      end
    end

    context "secret token is not set" do
      it "no verification of request" do
        body = File.read("spec/fixtures/webhook_body.json")

        allow(CircleReaper::CircleWorker).to receive(:perform_in)

        post "/payload", body

        expect(last_response).to be_ok
      end
    end
  end
end
