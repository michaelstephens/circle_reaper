require "active_support/core_ext/hash/indifferent_access"
require "json"

module CircleReaper
  class App < Sinatra::Base
    get "/" do
      "Hello World!"
    end

    post "/payload" do
      payload = JSON.parse(
        request.body.read,
        object_class: HashWithIndifferentAccess
      )

      if ENV['SECRET_TOKEN']
        request.body.rewind
        payload_body = request.body.read
        verify_signature(payload_body)
      end

      commits = payload.fetch(:commits)
      if commits.none? { |commit| commit.fetch(:message).include?("[run circle]") }
        CircleWorker.perform_in(30.seconds, payload)
      end
    end

    def verify_signature(payload_body)
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('SECRET_TOKEN'), payload_body)
      return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
  end
end
