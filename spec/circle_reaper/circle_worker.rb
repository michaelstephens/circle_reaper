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
  end
end
