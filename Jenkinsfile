pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                deleteDir()
                checkout scmGit(
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[url: 'https://github.com/JavaKoala/home_calendar']])
            }
        }
        stage('build') {
            steps {
                sh """#!/bin/bash
                  export HOME="/var/snap/jenkins/current"
                  source /etc/profile
                  rvm use 4.0.3
                  bundle install
                  cp config/database.yml.sample config/database.yml
                  sed -i 's/password:/password: password/' config/database.yml
                  RAILS_ENV=test bundle exec rails db:reset
                  bin/ci
                """
            }
        }
    }
}
