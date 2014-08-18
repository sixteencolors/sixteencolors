-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Mon Aug 18 14:33:55 2014
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `artist`;

--
-- Table: `artist`
--
CREATE TABLE `artist` (
  `id` bigint NOT NULL auto_increment,
  `name` text NOT NULL,
  `shortname` varchar(128) NOT NULL,
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` timestamp NULL,
  PRIMARY KEY (`id`),
  UNIQUE `artist_shortname` (`shortname`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `grp`;

--
-- Table: `grp`
--
CREATE TABLE `grp` (
  `id` bigint NOT NULL auto_increment,
  `name` text NOT NULL,
  `shortname` varchar(128) NOT NULL,
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` timestamp NULL,
  PRIMARY KEY (`id`),
  UNIQUE `grp_shortname` (`shortname`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `pack`;

--
-- Table: `pack`
--
CREATE TABLE `pack` (
  `id` bigint NOT NULL auto_increment,
  `file_path` text NOT NULL,
  `filename` varchar(128) NOT NULL,
  `shortname` varchar(128) NOT NULL,
  `year` integer NOT NULL,
  `month` integer NULL,
  `approved` enum('0','1') NOT NULL DEFAULT '0',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` timestamp NULL,
  PRIMARY KEY (`id`),
  UNIQUE `pack_filename` (`filename`),
  UNIQUE `pack_shortname` (`shortname`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `file`;

--
-- Table: `file`
--
CREATE TABLE `file` (
  `id` bigint NOT NULL auto_increment,
  `pack_id` bigint NOT NULL,
  `filename` varchar(128) NOT NULL,
  `file_path` text NOT NULL,
  `type` varchar(80) NULL,
  `read_options` varchar(128) NOT NULL DEFAULT '{}',
  `render_options` varchar(128) NOT NULL DEFAULT '{}',
  `blocked` enum('0','1') NULL DEFAULT '0',
  `root_id` integer NULL,
  `lft` integer NOT NULL,
  `rgt` integer NOT NULL,
  `level` integer NOT NULL,
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` timestamp NULL,
  INDEX `file_idx_pack_id` (`pack_id`),
  PRIMARY KEY (`id`),
  UNIQUE `file_pack_id_filename` (`pack_id`, `filename`),
  CONSTRAINT `file_fk_pack_id` FOREIGN KEY (`pack_id`) REFERENCES `pack` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `artist_group_join`;

--
-- Table: `artist_group_join`
--
CREATE TABLE `artist_group_join` (
  `artist_id` bigint NOT NULL,
  `group_id` bigint NOT NULL,
  INDEX `artist_group_join_idx_group_id` (`group_id`),
  INDEX `artist_group_join_idx_artist_id` (`artist_id`),
  PRIMARY KEY (`artist_id`, `group_id`),
  CONSTRAINT `artist_group_join_fk_group_id` FOREIGN KEY (`group_id`) REFERENCES `grp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `artist_group_join_fk_artist_id` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `file_sauce`;

--
-- Table: `file_sauce`
--
CREATE TABLE `file_sauce` (
  `file_id` bigint NOT NULL,
  `sauce_id` char(5) NOT NULL DEFAULT 'SAUCE',
  `version` char(2) NOT NULL DEFAULT '00',
  `title` varchar(35) NULL,
  `author` varchar(20) NULL,
  `grp` varchar(20) NULL,
  `date` varchar(8) NULL,
  `filesize` integer NOT NULL DEFAULT 0,
  `filetype_id` integer NOT NULL DEFAULT 0,
  `datatype_id` integer NOT NULL DEFAULT 0,
  `tinfo1` integer NOT NULL DEFAULT 0,
  `tinfo2` integer NOT NULL DEFAULT 0,
  `tinfo3` integer NOT NULL DEFAULT 0,
  `tinfo4` integer NOT NULL DEFAULT 0,
  `comment_count` integer NOT NULL DEFAULT 0,
  `flags_id` integer NOT NULL DEFAULT 0,
  `filler` varchar(22) NOT NULL DEFAULT '                      ',
  `comment_id` char(5) NOT NULL DEFAULT 'COMNT',
  `comments` text NULL,
  INDEX (`file_id`),
  PRIMARY KEY (`file_id`),
  CONSTRAINT `file_sauce_fk_file_id` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `file_source`;

--
-- Table: `file_source`
--
CREATE TABLE `file_source` (
  `file_id` bigint NOT NULL,
  `source` text NOT NULL,
  INDEX (`file_id`),
  PRIMARY KEY (`file_id`),
  CONSTRAINT `file_source_fk_file_id` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `pack_group_join`;

--
-- Table: `pack_group_join`
--
CREATE TABLE `pack_group_join` (
  `pack_id` bigint NOT NULL,
  `group_id` bigint NOT NULL,
  INDEX `pack_group_join_idx_group_id` (`group_id`),
  INDEX `pack_group_join_idx_pack_id` (`pack_id`),
  PRIMARY KEY (`pack_id`, `group_id`),
  CONSTRAINT `pack_group_join_fk_group_id` FOREIGN KEY (`group_id`) REFERENCES `grp` (`id`),
  CONSTRAINT `pack_group_join_fk_pack_id` FOREIGN KEY (`pack_id`) REFERENCES `pack` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `file_artist_join`;

--
-- Table: `file_artist_join`
--
CREATE TABLE `file_artist_join` (
  `file_id` bigint NOT NULL,
  `artist_id` bigint NOT NULL,
  INDEX `file_artist_join_idx_artist_id` (`artist_id`),
  INDEX `file_artist_join_idx_file_id` (`file_id`),
  PRIMARY KEY (`file_id`, `artist_id`),
  CONSTRAINT `file_artist_join_fk_artist_id` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`),
  CONSTRAINT `file_artist_join_fk_file_id` FOREIGN KEY (`file_id`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

