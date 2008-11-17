-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Nov 17 10:19:32 2008
-- 
BEGIN TRANSACTION;


--
-- Table: twitter
--
DROP TABLE twitter;
CREATE TABLE twitter (
  id integer NOT NULL,
  time datetime NOT NULL,
  user varchar NOT NULL,
  message varchar(256) NOT NULL
);


COMMIT;
