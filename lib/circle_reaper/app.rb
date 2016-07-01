require "sinatra"
require "json"
require "active_support/hash_with_indifferent_access"
require "circle_reaper/circle_worker"
require 'logger'

module CircleReaper
  class App < Sinatra::Base
    get "/" do
      "Hello World!"
    end

    post "/payload" do
      logger = Logger.new(STDOUT)

      payload = JSON.parse(
        request.body.read,
        object_class: HashWithIndifferentAccess
      )
      logger.info(payload)

      unless payload.fetch(:comment).fetch(:body).include?("[run circle]")
        CircleWorker.perform_async(payload)
      end
    end
  end
end
