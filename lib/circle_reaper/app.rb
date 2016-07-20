require "active_support/core_ext/hash/indifferent_access"
require "json"

module CircleReaper
  class App < Sinatra::Base
    get "/" do
      "Hello World!"
    end

    post "/payload" do
      payload_body = request.body.read

      if ENV["SECRET_TOKEN"]
        verify_signature(payload_body)
      end

      payload = JSON.parse(
        payload_body,
        object_class: HashWithIndifferentAccess
      )

      commits = payload.fetch(:commits)
      if commits.none? { |commit| commit.fetch(:message).include?("[run circle]") }
        CircleWorker.perform_in(30.seconds, payload)
      end
    end

    def verify_signature(payload_body)
      digest = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha1"),
        ENV.fetch("SECRET_TOKEN"),
        payload_body
      )

      signature = "sha1=" + digest

      unless Rack::Utils.secure_compare(signature, request.env["HTTP_X_HUB_SIGNATURE"])
        return halt 500, "Signatures didn't match!"
      end
    end
  end
end
