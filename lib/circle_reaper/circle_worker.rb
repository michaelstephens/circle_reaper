module CircleReaper
  class CircleWorker
    include Sidekiq::Worker

    def perform(payload)
      owner  = payload.fetch(:repository).fetch(:owner).fetch(:name)
      repo   = payload.fetch(:repository).fetch(:name)
      branch = payload.fetch(:ref).split("/").last

      return if branch == "master"

      if builds.count > 1
        builds.drop(1).each do |build|
          CircleCi::Build.cancel(owner, repo, build["build_num"])
        end
      end
    end

    def builds
      @builds ||= find_builds
    end

    def find_builds
      recent_builds_branch.select do |build|
        build["stop_time"].nil? && build["why"] == "github"
      end
    end

    def recent_builds_response
      CircleCi::Project.recent_builds_branch(owner, repo, branch).body
    end
  end
end
