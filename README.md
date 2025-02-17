# README

This is a calendar application based on Drifting Ruby's calendar application ( https://www.driftingruby.com/episodes/fullcalendar-events-and-scheduling )
It uses Ruby on Rails with MySQL, FullCalendar ( https://fullcalendar.io ), and moment.js ( https://momentjs.com )
The goal of this project was to learn about FullCalendar and make something mobile friendly.
To that end this application differs from Drifting Ruby's in that it uses HTML5 datetime pickers in the event forms.
The FullCalendar configuration is also more mobile friendly.

## OSX Development Setup

### Install homebrew

https://brew.sh

### Install Mysql

brew install mysql
Don't forget to secure your installation!

### Install Ruby version 3.4.2

I like rbenv ( https://github.com/rbenv/rbenv ), but rvm works too

### Clone the repository

git clone https://github.com/JavaKoala/home_calendar.git

### Application setup (in the folder with the application)

1. gem install bundler
2. bundle install
3. cp config/database.yml.sample config/database.yml
4. update database.yml to your database configuration
5. bundle exec rake db:create
6. bundle exec rake db:migrate
7. bundle exec rake test
8. bundle exec rails server
9. go to http://localhost:3000 in a web browser to see the application

## Docker Build and Run

1. Build image
`docker buildx build --tag home_calendar github.com/JavaKoala/home_calendar`
2. Run image
```
docker run -it --rm --name home_calendar -p 3000:3000 \
  -e SECRET_KEY_BASE=<<Your Secret Key Base>> \
  -e DATABASE_URL="mysql2://<<Your User>>:<<Your Password>>@host.docker.internal/home_calendar_production" \
  -e RAILS_SERVE_STATIC_FILES=true \
  home_calendar
```
3. Create database
```
docker exec home_calendar bundle exec rails db:create
docker exec home_calendar bundle exec rails db:migrate
```
4. Go to http://localhost:3000 in a web browser to see the application
