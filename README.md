# Circle Reaper [![CircleCI](https://circleci.com/gh/mikestephens/circle_reaper/tree/master.svg?style=svg)](https://circleci.com/gh/mikestephens/circle_reaper/tree/master)

A Github bot that cancels redundant circle builds!

Circle Reaper scans your repository after a push and cancels all but the latest build on any given branch (except master!).


Based on the fine work of [mikeastock's pipefitter](https://github.com/mikeastock/pipefitter)


## How to Run
`rackup` && `sidekiq -C config/sidekiq.yml -r ./boot.rb`

## Configuration
### Env vars
- `REDIS_URL` set for redis
- `SIDEKIQ_USERNAME` & `SIDEKIQ_PASSWORD` for sidekiq authentication
- `CIRCLECI_TOKEN` for circle access
- `SECRET_TOKEN` set this as the secret in the Github Webhook for authentication

## How to use
### Setup
- Have this app exposed and running with a url (heroku is great for this)
- Add a Github Webhook for your exposed endpoint (ex: http://mysite.com/payload)

### Tips
- Adding `[run circle]` to your commit will skip this bot

## Limitations
- Right now if any commits in a push contain "[run circle]" all commits will run circle.
- If you push right after a "[run circle]" commit, circle will be cancelled.
