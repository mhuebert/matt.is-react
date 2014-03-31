#!/bin/bash
heroku create $1
heroku domains:add $1.sparkboard.com --app $1
heroku addons:add mongohq --app $1