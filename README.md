# BusYatra - Bus Booking System

A Ruby on Rails application implementing a seat-based bus ticket booking system
with strict concurrency control and background seat-release logic.

## Features
- Email authentication
- Trip search with filters
- Seat locking with expiration
- Booking confirmation
- Cancellation with refund rules

## Concurrency
Seat locking is enforced at the database level using PostgreSQL partial unique
indexes to guarantee no double booking under concurrent access.

## Background Jobs
Seat holds automatically expire after 5 minutes using Sidekiq.

## Running
clone the repo and `cd` into the directory:

```
git clone  https://github.com/vijirajtp/bus-yatra 
cd bus-yatra
```
Install the needed packages
```
bundle install
```
Then, migrate the database:
```
rails db:create db:migrate
```
Now, you’ll be ready to seed the database with sample users, buses, trips and run the app in a local server. Before starting the server, manually trigger the Dart Sass build to ensure the necessary CSS file exist:
```
rails db:seed
bundle exec rails dartsass:build
bin/dev
```
Run the background job (Sidekiq) in another tab
```
bundle exec sidekiq
```

## Testing
```
bundle exec rspec
```