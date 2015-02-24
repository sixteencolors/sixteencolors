-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Mon Feb 23 22:03:23 2015
-- 
--
-- Table: artist
--
DROP TABLE artist CASCADE;
CREATE TABLE artist (
  id serial NOT NULL,
  name character varying(512) NOT NULL,
  shortname character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (id),
  CONSTRAINT artist_shortname UNIQUE (shortname)
);

--
-- Table: grp
--
DROP TABLE grp CASCADE;
CREATE TABLE grp (
  id serial NOT NULL,
  name character varying(512) NOT NULL,
  shortname character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (id),
  CONSTRAINT grp_shortname UNIQUE (shortname)
);

--
-- Table: pack
--
DROP TABLE pack CASCADE;
CREATE TABLE pack (
  id serial NOT NULL,
  file_path character varying(512) NOT NULL,
  filename character varying(128) NOT NULL,
  shortname character varying(128) NOT NULL,
  year integer NOT NULL,
  month integer,
  approved boolean DEFAULT '0' NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (id),
  CONSTRAINT pack_filename UNIQUE (filename),
  CONSTRAINT pack_shortname UNIQUE (shortname)
);

--
-- Table: artist_tag
--
DROP TABLE artist_tag CASCADE;
CREATE TABLE artist_tag (
  artist_id bigint NOT NULL,
  tag character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (artist_id, tag)
);
CREATE INDEX artist_tag_idx_artist_id on artist_tag (artist_id);

--
-- Table: file
--
DROP TABLE file CASCADE;
CREATE TABLE file (
  id serial NOT NULL,
  pack_id bigint NOT NULL,
  filename character varying(128) NOT NULL,
  file_path character varying(512) NOT NULL,
  type character varying(80),
  read_options character varying(128) DEFAULT '{}' NOT NULL,
  render_options character varying(128) DEFAULT '{}' NOT NULL,
  blocked boolean DEFAULT '0',
  root_id integer,
  lft integer NOT NULL,
  rgt integer NOT NULL,
  level integer NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (id),
  CONSTRAINT file_pack_id_filename UNIQUE (pack_id, filename)
);
CREATE INDEX file_idx_pack_id on file (pack_id);

--
-- Table: group_tag
--
DROP TABLE group_tag CASCADE;
CREATE TABLE group_tag (
  group_id bigint NOT NULL,
  tag character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (group_id, tag)
);
CREATE INDEX group_tag_idx_group_id on group_tag (group_id);

--
-- Table: pack_tag
--
DROP TABLE pack_tag CASCADE;
CREATE TABLE pack_tag (
  pack_id bigint NOT NULL,
  tag character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (pack_id, tag)
);
CREATE INDEX pack_tag_idx_pack_id on pack_tag (pack_id);

--
-- Table: artist_group_join
--
DROP TABLE artist_group_join CASCADE;
CREATE TABLE artist_group_join (
  artist_id bigint NOT NULL,
  group_id bigint NOT NULL,
  PRIMARY KEY (artist_id, group_id)
);
CREATE INDEX artist_group_join_idx_group_id on artist_group_join (group_id);
CREATE INDEX artist_group_join_idx_artist_id on artist_group_join (artist_id);

--
-- Table: file_sauce
--
DROP TABLE file_sauce CASCADE;
CREATE TABLE file_sauce (
  file_id bigint NOT NULL,
  sauce_id character(5) DEFAULT 'SAUCE' NOT NULL,
  version character(2) DEFAULT '00' NOT NULL,
  title character varying(35),
  author character varying(20),
  grp character varying(20),
  date character varying(8),
  filesize integer DEFAULT 0 NOT NULL,
  filetype_id integer DEFAULT 0 NOT NULL,
  datatype_id integer DEFAULT 0 NOT NULL,
  tinfo1 integer DEFAULT 0 NOT NULL,
  tinfo2 integer DEFAULT 0 NOT NULL,
  tinfo3 integer DEFAULT 0 NOT NULL,
  tinfo4 integer DEFAULT 0 NOT NULL,
  comment_count integer DEFAULT 0 NOT NULL,
  flags_id integer DEFAULT 0 NOT NULL,
  filler character varying(22) DEFAULT '                      ' NOT NULL,
  comment_id character(5) DEFAULT 'COMNT' NOT NULL,
  comments text,
  PRIMARY KEY (file_id)
);

--
-- Table: file_source
--
DROP TABLE file_source CASCADE;
CREATE TABLE file_source (
  file_id bigint NOT NULL,
  source text NOT NULL,
  PRIMARY KEY (file_id)
);

--
-- Table: file_tag
--
DROP TABLE file_tag CASCADE;
CREATE TABLE file_tag (
  file_id bigint NOT NULL,
  tag character varying(128) NOT NULL,
  ctime timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  mtime timestamp,
  PRIMARY KEY (file_id, tag)
);
CREATE INDEX file_tag_idx_file_id on file_tag (file_id);

--
-- Table: pack_group_join
--
DROP TABLE pack_group_join CASCADE;
CREATE TABLE pack_group_join (
  pack_id bigint NOT NULL,
  group_id bigint NOT NULL,
  PRIMARY KEY (pack_id, group_id)
);
CREATE INDEX pack_group_join_idx_group_id on pack_group_join (group_id);
CREATE INDEX pack_group_join_idx_pack_id on pack_group_join (pack_id);

--
-- Table: file_artist_join
--
DROP TABLE file_artist_join CASCADE;
CREATE TABLE file_artist_join (
  file_id bigint NOT NULL,
  artist_id bigint NOT NULL,
  PRIMARY KEY (file_id, artist_id)
);
CREATE INDEX file_artist_join_idx_artist_id on file_artist_join (artist_id);
CREATE INDEX file_artist_join_idx_file_id on file_artist_join (file_id);

--
-- Foreign Key Definitions
--

ALTER TABLE artist_tag ADD CONSTRAINT artist_tag_fk_artist_id FOREIGN KEY (artist_id)
  REFERENCES artist (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE file ADD CONSTRAINT file_fk_pack_id FOREIGN KEY (pack_id)
  REFERENCES pack (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE file ADD CONSTRAINT file_fk_root_id FOREIGN KEY (root_id)
  REFERENCES file (root_id) ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE group_tag ADD CONSTRAINT group_tag_fk_group_id FOREIGN KEY (group_id)
  REFERENCES grp (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE pack_tag ADD CONSTRAINT pack_tag_fk_pack_id FOREIGN KEY (pack_id)
  REFERENCES pack (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE artist_group_join ADD CONSTRAINT artist_group_join_fk_group_id FOREIGN KEY (group_id)
  REFERENCES grp (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE artist_group_join ADD CONSTRAINT artist_group_join_fk_artist_id FOREIGN KEY (artist_id)
  REFERENCES artist (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE file_sauce ADD CONSTRAINT file_sauce_fk_file_id FOREIGN KEY (file_id)
  REFERENCES file (id) ON DELETE CASCADE DEFERRABLE;

ALTER TABLE file_source ADD CONSTRAINT file_source_fk_file_id FOREIGN KEY (file_id)
  REFERENCES file (id) ON DELETE CASCADE DEFERRABLE;

ALTER TABLE file_tag ADD CONSTRAINT file_tag_fk_file_id FOREIGN KEY (file_id)
  REFERENCES file (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE pack_group_join ADD CONSTRAINT pack_group_join_fk_group_id FOREIGN KEY (group_id)
  REFERENCES grp (id) DEFERRABLE;

ALTER TABLE pack_group_join ADD CONSTRAINT pack_group_join_fk_pack_id FOREIGN KEY (pack_id)
  REFERENCES pack (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE file_artist_join ADD CONSTRAINT file_artist_join_fk_artist_id FOREIGN KEY (artist_id)
  REFERENCES artist (id) DEFERRABLE;

ALTER TABLE file_artist_join ADD CONSTRAINT file_artist_join_fk_file_id FOREIGN KEY (file_id)
  REFERENCES file (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

