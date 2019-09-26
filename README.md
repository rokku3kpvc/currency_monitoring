# Live dollar rates monitoring app

This app demonstrates lifetime dollar rates from [CBR](https://www.cbr.ru/currency_base/daily/).

## Installation

Follow these easy steps to install and start the app:

### Configure App

This app uses cron scheduled jobs with [sidekiq](https://github.com/mperham/sidekiq) adapter. Sodekiq use Redis for storing jobs cache, please install it before you'll run the app. You could configure it in `config/schedule.rb`. I recommend to run cron jobs from rvm virtual environment. When you create one, please change `runner_with_rvm` job type in scheduled file.  
Also you need to set environment variables to connect with db and get access to `/admin` page.  
For storing env variables app use [figaro](https://github.com/laserlemon/figaro) gem.
At last you should install [foreman](https://github.com/ddollar/foreman) for start this application.

### Set up Rails app

First, install the gems required by the application:

    bundle

Next, execute the database migrations/schema setup:

	rails db:setup

### Start the app :rocket:

Once all prepares were made, simply use foreman command for start rails and sidekiq servers.

    foreman start

## So? ...

This app was the last part of FunBox QT. I hope you like it :)  
Wish u a nice coding