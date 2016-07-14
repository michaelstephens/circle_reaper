require_relative "../config/circle"
require_relative "../config/sidekiq"

require "circle_reaper/app"
require "circle_reaper/circle_worker"

module CircleReaper
end
