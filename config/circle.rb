CircleCi.configure do |config|
  config.token = ENV.fetch("CIRCLECI_TOKEN")
end
