# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

## DB Migration with Heroku

### Mac
### First Time Setup

* Install Heroku CLI `brew tap heroku/brew && brew install heroku`
* Run command `heroku login`

### Migration
* Create your migration script
* Run the scripts locally
* Push scripts to git and merge them to `master`
* Run `heroku run rake db:migrate -a upspaceca`

### Visual Changes
Before committing run `RAILS_ENV=production bundle exec rake assets:precompile` to compile assets

## Tests
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
