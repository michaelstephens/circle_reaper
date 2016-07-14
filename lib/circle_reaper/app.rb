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

      commits = payload.fetch(:commits)

      if commits.none? { |commit| commit.fetch(:message).include?("[run circle]") }
        CircleWorker.perform_async(payload)
      end
    end
  end
end
