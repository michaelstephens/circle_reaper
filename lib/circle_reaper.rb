require_relative "../config/circle"
require_relative "../config/sidekiq"

require "circle_reaper/app"
require "circle_reaper/circle_worker"
require "circle_reaper/reaper"

module CircleReaper
  def self.github_client
    @github_client ||= Github.new(basic_auth: ENV.fetch("GITHUB_TOKEN"))
  end
end
