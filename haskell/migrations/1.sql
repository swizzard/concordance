CREATE SCHEMA IF NOT EXISTS api;

CREATE TABLE IF NOT EXISTS api.author (
  id serial primary key,
  name text
);

CREATE TABLE IF NOT EXISTS api.doc (
  id serial primary key,
  title text,
  year integer
);

CREATE TABLE IF NOT EXISTS api.author_doc (
  id bigserial primary key,
  author_id integer REFERENCES api.author(id),
  doc_id integer REFERENCES api.doc(id)
);

CREATE TABLE IF NOT EXISTS api.genre (
  id serial primary key,
  name text
);

CREATE TABLE IF NOT EXISTS api.genre_doc (
  id bigserial primary key,
  genre_id integer REFERENCES api.genre(id),
  doc_id integer REFERENCES api.doc(id)
);

CREATE TABLE IF NOT EXISTS api.word_info (
  id bigserial primary key,
  literal_value text,
  pos varchar(20),
  stem text,
  UNIQUE (literal_value, pos, stem)
);

CREATE TABLE IF NOT EXISTS api.token (
  doc_id integer REFERENCES api.doc(id),
  word_id integer REFERENCES api.word_info(id),
  author_id integer REFERENCES api.author(id),
  line_no integer,
  idx_in_line integer,
  UNIQUE (doc_id, line_no, idx_in_line)
);

CREATE INDEX IF NOT EXISTS tokIdxInLine on api.token (idx_in_line);
CREATE INDEX IF NOT EXISTS tokLineNo on api.token (line_no);
CREATE INDEX IF NOT EXISTS tokWordId on api.token (word_id);

DROP ROLE IF EXISTS public_role;
CREATE ROLE public_role;
GRANT public_role TO public_anon;
GRANT public_role TO postgres;

GRANT usage ON SCHEMA api TO public_role;
GRANT SELECT ON ALL TABLES IN SCHEMA api TO public_role;

DROP ROLE IF EXISTS concordance_role;
CREATE ROLE concordance_role;
GRANT concordance_role TO postgres;
GRANT concordance_role TO app_user;
GRANT usage ON SCHEMA api TO concordance_role;
GRANT ALL ON ALL TABLES IN SCHEMA api TO concordance_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA api TO concordance_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA api TO concordance_role;
