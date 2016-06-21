require "sinatra"
require "json"
require "active_support/hash_with_indifferent_access"

require "circle_reaper/circle_worker"

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

      if payload.fetch(:comment).fetch(:body).include?("circle_reaper")
        StructureWorker.perform_async(payload)
      end
    end
  end
end
