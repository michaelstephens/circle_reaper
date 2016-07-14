RSpec.describe CircleReaper::CircleWorker do
  describe "#perform" do
    let(:owner) { "mikestephens" }
    let(:repo) { "tweeter" }
    let(:ref) { "refs/head/test" }
    let(:payload) do
      {
        repository: {
          name: repo,
          owner: {
            login: owner
          }
        },
        ref: ref
      }
    end
  end
end
