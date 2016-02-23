## Tweet Aquarium

This was one of the homework exercises during my time at General Assembly's Web Development Immersive bootcamp.

## Task

Using the Twitter API, build a backend that stores a limited number of tweets in the database seed file so that it can be used to show clients where internet access is unavailable. The bonus task was to create a frontend that showed fish with tweets.

## Solution

Seeing as we had public holiday (yay Australia day) to complete this task, I added a few more things.

## Features

* 6 fish occupy the screen at a time
* When a fish goes off screen:
  * a new tweet will be retrieved
  * the size changes randomly
  * the vertical position changes randomly
  * the swimming speed changes randomly
* Hover over fish to stop them and to bring them to the foreground
* Retrieve new tweets using the rakefile

## Technologies

* jQuery
* AJAX
* Rails
* [Twitter gem](https://github.com/sferik/twitter)

## Config

Get the [postgresql mac app](http://postgresapp.com/) and run it.

```
rake db:create
rake db:migrate
```

To seed the database with tweets you can either:

Get `limit` number of tweets with `search term`

```
rake twitter:search['search term',limit]
```

Get `limit` number of tweets from `user`

```
rake twitter:from['user',limit]
```

Then run `rails s` to start the server.

You can also do `rake twitter:clear` to delete all previous tweets in the database if you want to start fresh.

