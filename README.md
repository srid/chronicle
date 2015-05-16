# chronicle

This is v2 of [feelings](https://github.com/srid/feelings). Work in progress.

## Tech

* PostgreSQL exposed over the web as a REST API (see [postgrest](https://github.com/begriffs/postgrest))
* [Elm](http://elm-lang.org/) for FRP-based frontend.
* [Bootstrap](http://getbootstrap.com/) HTML/CSS framework

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

## WHITEBOARD

Basic idea is to keep track of a **tree of memories**. Accumulation of data occurs at the level of leaves (individual moments), from which we "fold" the memories to summarize at every ancestory. For example, we fold all moments of the day to summarize the value for that day, and then fold all days to summarize for that week, then month, year and so on.

All level of summarizations are ultimately linked to the specific moments (thus forming a tree) that can be consulted at any time. We thus create "memories" that are formed at individual moments without the bias of faulty recall.

Each entries can have metadata for later use. A special "notes" metadata key holds Markdown formatted notes (the memory 'content').

All entries belong to a "channel". A channel has a recommended set of metadata. The following channels are currently known:

* Channel "feeling", with metadata: how, what, trigger.
* Channel "work/<company>", with metadata: project, people, ...
* Channel "travel/india-trip-2015", with metadata: location, people, ...

### User Interface

As memories are stored as trees, it is fitting to use a "zoomable calendar". Start with calendar view, that can be zoomed in or out, with colored markers on individual cells. See http://bootstrap-calendar.azurewebsites.net/index-bs3.html

### Database notes

Use `\d+ 1.feelings` to inspect the view.

Use `ALTER ROLE <username> SET timezone = 'America/Vancouver';` to set database timezone. This however doesn't automatically change the day end marker from 12am to something custom (like 3am).

TODO: dump schema into git repo.

### Data model

Generalize "feeling" into "events". Feelings are just one kind of events. Tracking work progress log, including challenges and achievements, is another example. Events have metadata represented using [PostgreSQL JSON types](https://blog.heroku.com/archives/2012/12/6/postgres_92_now_available#json-support).

* **Feeling kind** may require these metadata: *type* (good, bad, neutral), *label* (what is the feeling?), *trigger*.

* **WorkLog kind** may require: *type* (accomplished, hindrance, misc), *project* (associated project), *desc*


## Elm package ideas

Some new packages I can create by extracing code from this repo:

* Date formatter
* Time ago (eg.: `23 secs ago`)
* Search query parser (see `src/Search.elm`)
* Bootstrap.elm (maybe [use this](https://github.com/circuithub/elm-bootstrap-html)?)
