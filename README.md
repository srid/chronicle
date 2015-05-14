# chronicle

This is v2 of [feelings](https://github.com/srid/feelings). Work in progress.

## HACKING

Use Heroku Docker CLI plugin for development and deployment.

```
make
```

## Data model

Generalize "feeling" into "events". Feelings are just one kind of events. Tracking work progress log, including challenges and achievements, is another example. Events have metadata represented using [PostgreSQL JSON types](https://blog.heroku.com/archives/2012/12/6/postgres_92_now_available#json-support).

* **Feeling kind** may require these metadata: *type* (good, bad, neutral), *label* (what is the feeling?), *trigger*.

* **WorkLog kind** may require: *type* (accomplished, hindrance, misc), *project* (associated project), *desc*
