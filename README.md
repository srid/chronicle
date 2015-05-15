# chronicle

This is v2 of [feelings](https://github.com/srid/feelings). Work in progress.

## Tech

* PostgreSQL exposed over the web as a REST API using (see [postgrest](https://github.com/begriffs/postgrest))
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

## Data model

Generalize "feeling" into "events". Feelings are just one kind of events. Tracking work progress log, including challenges and achievements, is another example. Events have metadata represented using [PostgreSQL JSON types](https://blog.heroku.com/archives/2012/12/6/postgres_92_now_available#json-support).

* **Feeling kind** may require these metadata: *type* (good, bad, neutral), *label* (what is the feeling?), *trigger*.

* **WorkLog kind** may require: *type* (accomplished, hindrance, misc), *project* (associated project), *desc*
