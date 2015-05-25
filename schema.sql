CREATE TYPE feelingkind AS ENUM (
    'good',
    'meh',
    'bad',
    'great',
    'terrible'
);


CREATE TABLE feelings (
    how feelingkind DEFAULT 'meh'::feelingkind NOT NULL,
    what text,
    trigger text,
    notes text,
    at timestamp with time zone DEFAULT now() NOT NULL,
    id bigserial
);

-- The "1" schema is used by spas (postgrest)

CREATE SCHEMA "1";

CREATE VIEW "1".feelings AS
 SELECT feelings.how,
    feelings.what,
    feelings.trigger,
    feelings.notes,
    feelings.at,
    feelings.id
   FROM public.feelings
  ORDER BY feelings.at DESC;
