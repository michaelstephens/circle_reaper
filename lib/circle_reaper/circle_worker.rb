require "sidekiq"

require "circle_reaper/pull_request"
require "circle_reaper/structure_builder"

module CircleReaper
  class CircleWorker
    def perform(payload)
      owner = owner: payload.fetch(:repository).fetch(:owner).fetch(:login)
      repo  = payload.fetch(:repository).fetch(:name)
      branch = PullRequest.find(owner: owner,
                              repo: repo,
                              number: payload.fetch(:issue).fetch(:number)).branch


      builds = CircleCi::Project.recent_builds_branch(owner, repo, branch).body.select{|build| build["stop_time"].nil? && build["why"] == "github"}
      if builds.count > 1
        builds[0..-2].each do |build|
          CircleCi::Build.cancel owner, repo, build["build_num"]
        end
      end
    end
  end
end