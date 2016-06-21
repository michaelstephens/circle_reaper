RSpec.describe CircleReaper::CircleWorker do
  describe "#perform" do
    let(:owner) { "mikestephens" }
    let(:repo) { "tweeter" }
    let(:number) { 1 }
    let(:payload) do
      {
        repository: {
          name: repo,
          owner: {
            login: owner
          }
        },
        issue: {
          number: number
        }
      }
    end

    it "find's the base pull request" do
      allow(CircleReaper::PullRequest).to receive(:create) { spy }

      expect(CircleReaper::PullRequest).to receive(:find).with(
        owner: owner,
        repo: repo,
        number: number
      ) { spy }

      CircleReaper::CircleWorker.new.perform(payload)
    end
  end
end
