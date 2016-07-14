require "sidekiq"
require "circle_reaper/pull_request"

module CircleReaper
  class CircleWorker
    def perform(payload)
      owner  = payload.fetch(:repository).fetch(:owner).fetch(:name)
      repo   = payload.fetch(:repository).fetch(:name)
      branch = payload.fetch(:ref).split('/').last

      unless branch == "master"
        builds = CircleCi::Project.recent_builds_branch(owner, repo, branch).body.select{|build| build["stop_time"].nil? && build["why"] == "github"}
        if builds.count > 1
          builds.drop(1).each do |build|
            CircleCi::Build.cancel owner, repo, build["build_num"]
          end
        end
      end
    end
  end
end
