## Circle Reaper

[![CircleCI](https://circleci.com/gh/mikestephens/circle_reaper/tree/master.svg?style=svg)](https://circleci.com/gh/mikestephens/circle_reaper/tree/master)

A Github bot that cancels redundant circle builds.


Based on the fine work of [mikeastock's pipefitter](https://github.com/mikeastock/pipefitter)


#### How to Run
`rackup` && `sidekiq -C config/sidekiq.yml -r ./boot.rb`


### Limitations
- Right now if any commits in a push contain "[run circle]" all commits will run circle.
- If you push right after a "[run circle]" commit, circle will be cancelled.
