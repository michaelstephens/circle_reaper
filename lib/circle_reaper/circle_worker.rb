require "active_support/core_ext/hash/indifferent_access"

module CircleReaper
  class CircleWorker
    include Sidekiq::Worker

    def perform(json)
      self.payload = HashWithIndifferentAccess.new(json)

      return if branch == "master"

      if builds.count > 1
        builds.drop(1).each do |build|
          CircleCi::Build.cancel(owner, repo, build["build_num"])
        end
      end
    end

    private

    attr_accessor :payload

    def builds
      @builds ||= find_builds
    end

    def find_builds
      recent_builds_response.select do |build|
        build["stop_time"].nil? && build["why"] == "github"
      end
    end

    def recent_builds_response
      CircleCi::Project.recent_builds_branch(owner, repo, branch).body
    end

    def owner
      payload.fetch(:repository).fetch(:owner).fetch(:name)
    end

    def repo
      payload.fetch(:repository).fetch(:name)
    end

    def branch
      payload.fetch(:ref).split("/").last
    end
  end
end
