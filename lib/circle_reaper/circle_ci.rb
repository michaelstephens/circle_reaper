require "github_api"

module CircleReaper
  class CircleCI
    def initialize(project)
      @project = ENV.fetch("PROJECT")
    end

    def self.find(owner:, repo:, number:)
      new(
        CircleReaper.github_client.pull_requests.find(owner, repo, number)
      )
    end

    def self.commit_shas(owner:, repo:, number:)
      new(
        CircleReaper.github_client.pull_requests.commits(owner, repo, number).map{|commit| commit.commit.to_hash}.
                                                                              select{|commit| Date.parse(commit["author"]["date"]) >= Date.today}.
                                                                              map{|commit| commit["tree"]["sha"]}
      )
    end

    def branch
      pull_request.head.ref
    end

    def number
      pull_request.number
    end

    private

    attr_reader :pull_request
  end
end
