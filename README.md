# chronicle

This is v2 of [feelings](https://github.com/srid/feelings). Work in progress. Read the sections titled Motivation and WHITEBOARD to understand the idea.

## Motivation

Humans are adept at denialism. The author therefore presumes that only a [data-centric approach](http://www.theatlantic.com/business/archive/2013/10/how-google-uses-data-to-build-a-better-worker/280347/) can be effective at improving human happiness.

Over time of data collection, one can't help but gain insights into what *actually* causes — as opposed to what one [remembers](https://en.wikipedia.org/wiki/List_of_memory_biases) or
is [taught](https://en.wikipedia.org/wiki/Social_conditioning) to be causing — one's happiness and unhappiness.

## Tech

* [spas](https://github.com/srid/spas) (via [PostgREST](https://github.com/begriffs/postgrest)) - automatic REST API for PostgreSQL
* [Elm](http://elm-lang.org/) - client-side language using FRP
* [Bootstrap](http://getbootstrap.com/) - HTML/CSS framework

## HACKING

Use Heroku Docker CLI plugin for deployment:

```
make release
```

and local build for development:

```
make run  # run spas from parent repo
make compile # rebuild Elm sources
```

## WHITEBOARD

Basic idea is to keep track of a **tree of memories**. Accumulation of data occurs at the level of leaf nodes (individual moments), from which we "fold" the memories up to summarize at at ancestry. Specifically, we fold all moments of the day to summarize the value for that day, and then fold all days to summarize for that week, then month, year and so on.

All level of summarizations are ultimately linked to the specific moments (thus forming a tree) that can be consulted at any time. We thus create reliable "memories" that are formed at individual moments without the bias of faulty recall.

Each entries can store custom metadata for later use. All entries have common fields like "created_at" (creation time), "notes" (markdown formatted notes, the memory 'content'). Use PostgreSQL JSON type for the arbitrary metadata so we don't have to keep changing the database schema (metadata changes is to be expected in future).

All entries belong to a "channel". A channel has a recommended set of metadata. The following channels are currently known:

* Channel "feeling", with metadata: how, what, trigger.
* Channel "work/<company>", with metadata: project, people, hindrance, ...
* Channel "travel/india-trip-2015", with metadata: location, people, ...

### Fold metrics

When folding also *aggregate* pre-defined metrics from individual entries. This should support:

* the color-coded daily markets in my blackboard
* habit tracking (eg: contemplate XYZ every day; with count=o or 1, accumulating over week/month/etc)

### Challenges

* How to represent such a flexible data model (above) without writing specific model/view code in Elm? We currently do this for the 'feelings' data model. Perhaps, just separate the channel spec as directories (`src/Elm/Channels/{Base,Feeling,Work}.elm`) for now, with a 'Base' channel that can be inherited for new channels.

  - Alternatively, drop the idea of channels in favour of the simplicity of having just one (feelings). Consequently make the feelings model a bit more generic (for example, rename "feeling" to "moment" and accordingly adjust its properties.)

### User Interface

As memories are stored as trees, it is fitting to use a "zoomable calendar". Start with calendar view, that can be zoomed in or out, with colored markers on individual cells. See http://bootstrap-calendar.azurewebsites.net/index-bs3.html

### Database notes

Use `\d+ 1.feelings` to inspect the view.

Use `ALTER ROLE <username> SET timezone = 'America/Vancouver';` to set database timezone. This however doesn't automatically change the day end marker from 12am to something custom (like 3am).

TODO: dump schema into git repo.

```
CREATE TABLE feelings_dev (
    how feelingkind DEFAULT 'meh'::feelingkind NOT NULL,
    what text,
    trigger text,
    notes text,
    at timestamp with time zone DEFAULT now() NOT NULL
);

create or replace view "1".feelings_dev as
SELECT *  FROM feelings_dev
 ORDER BY feelings_dev.at DESC;
```


## Elm package ideas

Some new packages I can create by extracing code from this repo:

* Date formatter
* Time ago (eg.: `23 secs ago`)
* Search query parser (see `src/Search.elm`)
* Bootstrap.elm (maybe [use this](https://github.com/circuithub/elm-bootstrap-html)?)
