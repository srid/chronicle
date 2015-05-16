# chronicle

This is v2 of [feelings](https://github.com/srid/feelings). Work in progress.

## Tech

* PostgreSQL exposed over the web as a REST API (see [postgrest](https://github.com/begriffs/postgrest))
* [Elm](http://elm-lang.org/) for FRP-based frontend.

## HACKING

Use Heroku Docker CLI plugin for deployment:

```
make release
```

and local build for development:

```
make run  # run postgrest (TODO: how to get it to build)
make compile # rebuild Elm sources
```

### Database notes

Use `\d+ 1.feelings` to inspect the view.

Use `ALTER ROLE <username> SET timezone = 'America/Vancouver';` to set database timezone. This however doesn't automatically change the day end marker from 12am to something custom (like 3am).

TODO: dump schema into git repo.

## Data model

Generalize "feeling" into "events". Feelings are just one kind of events. Tracking work progress log, including challenges and achievements, is another example. Events have metadata represented using [PostgreSQL JSON types](https://blog.heroku.com/archives/2012/12/6/postgres_92_now_available#json-support).

* **Feeling kind** may require these metadata: *type* (good, bad, neutral), *label* (what is the feeling?), *trigger*.

* **WorkLog kind** may require: *type* (accomplished, hindrance, misc), *project* (associated project), *desc*


## Elm package ideas

Some new packages I can create by extracing code from this repo:

* Date formatter
* Time ago (eg.: `23 secs ago`)
* Search query parser (see `src/Search.elm`)
