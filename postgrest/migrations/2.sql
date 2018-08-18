CREATE OR REPLACE FUNCTION api.get_or_create_author(n text) RETURNS int AS $$
DECLARE
  a_id int;
BEGIN
  INSERT INTO api.author(name) VALUES(n)
  RETURNING id
  INTO a_id;
  RETURN a_id;
EXCEPTION WHEN unique_violation THEN
  SELECT id
  FROM api.author
  WHERE name = $1
  INTO a_id;
  RETURN a_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_genre(n text) RETURNS int AS $$
DECLARE
  g_id int;
BEGIN
  INSERT INTO api.genre(name) VALUES(n)
  RETURNING id
  INTO g_id;
  RETURN g_id;
EXCEPTION WHEN unique_violation THEN
  SELECT id
  FROM api.genre
  WHERE name = n
  INTO g_id;
  RETURN g_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_author_doc(
  a_id int, d_id int) RETURNS int AS $$
BEGIN
  BEGIN
    INSERT INTO api.author_doc (author_id, doc_id) VALUES (a_id, d_id);
  EXCEPTION WHEN unique_violation THEN
  END;
  RETURN 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_genre_doc(
  g_id int, d_id int) RETURNS int AS $$
BEGIN
  BEGIN
    INSERT INTO api.genre_doc (genre_id, doc_id) VALUES (g_id, d_id);
  EXCEPTION WHEN unique_violation THEN
  END;
  RETURN 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_doc(
  t text, y int, r text, a text, g text) RETURNS int AS $$
DECLARE
  a_id int;
  d_id int;
  g_id int;
BEGIN
  SELECT api.get_or_create_author(a)
  INTO a_id;
  SELECT api.get_or_create_genre(g)
  INTO g_id;
  INSERT INTO api.doc(title, year, raw) VALUES (t, y, r)
  RETURNING id
  INTO d_id;
  PERFORM api.get_or_create_author_doc(a_id, d_id);
  PERFORM api.get_or_create_genre_doc(g_id, d_id);
  RETURN d_id;
EXCEPTION WHEN unique_violation THEN
  SELECT id
  FROM api.doc
  WHERE title = t
  AND year = y
  INTO d_id;
  RETURN d_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_word_info (
  l_v text, p varchar(20), s text) RETURNS int AS $$
DECLARE
  wi_id int;
BEGIN
  INSERT INTO api.word_info(literal_value, pos, stem) VALUES (l_v, p, s)
  RETURNING id
  INTO wi_id;
  RETURN wi_id;
EXCEPTION WHEN unique_violation THEN
  SELECT id
  FROM api.word_info
  WHERE literal_value = l_v
  AND pos = p
  AND stem = s
  INTO wi_id;
  RETURN wi_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION api.get_or_create_token(
  d_id int, a_id int,
  l_v text, p varchar(20), s text,
  l_n int, i_i_l int) RETURNS int AS $$
DECLARE
  wi_id int;
  t_id int;
BEGIN
  SELECT api.get_or_create_word_info(l_v, p, s)
  INTO wi_id;
  INSERT INTO api.token(doc_id, word_id, author_id, line_no, idx_in_line)
    VALUES (d_id, wi_id, a_id, l_n, i_i_l)
  RETURNING id
  INTO t_id;
  RETURN t_id;
EXCEPTION WHEN unique_violation THEN
  SELECT id
  FROM api.token
  WHERE doc_id = d_id
  AND line_no = l_n
  AND idx_in_line = i_i_l
  INTO t_id;
  RETURN t_id;
END;
$$ LANGUAGE plpgsql;
