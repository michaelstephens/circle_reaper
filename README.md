## Circle Reaper

[![CircleCI](https://circleci.com/gh/mikestephens/circle_reaper/tree/master.svg?style=svg)](https://circleci.com/gh/mikestephens/circle_reaper/tree/master)

A Github bot that cancels redundant circle builds.


Based on the fine work of [mikeastock's pipefitter](https://github.com/mikeastock/pipefitter)


#### How to Run
`rackup` && `sidekiq -C config/sidekiq.yml -r ./boot.rb`
