CREATE TYPE momentkind AS ENUM (
    'good',
    'meh',
    'bad',
    'great',
    'terrible'
);


CREATE TABLE moments (
    how momentkind DEFAULT 'meh'::momentkind NOT NULL,
    what text,
    trigger text,
    notes text,
    at timestamp with time zone DEFAULT now() NOT NULL,
    id bigserial
);

-- The "1" schema is used by spas (postgrest)

CREATE SCHEMA "1";

CREATE VIEW "1".moments AS
 SELECT moments.how,
    moments.what,
    moments.trigger,
    moments.notes,
    moments.at,
    moments.id
   FROM public.moments
  ORDER BY moments.at DESC;
