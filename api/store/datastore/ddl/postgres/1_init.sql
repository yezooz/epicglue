-- +migrate Up

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE item (
  id UUID PRIMARY KEY ,
  service_item_id VARCHAR(200) NOT NULL,
  item_type VARCHAR(20) NOT NULL,
  media_type VARCHAR(20) NOT NULL ,
  service_name VARCHAR(20) NOT NULL,
  title TEXT NULL ,
  description TEXT NULL ,
  author VARCHAR(100) NOT NULL,
  author_media JSON NULL ,
  media JSON NULL ,
  location_name TEXT NULL ,
  location_point POINT NULL ,
  link TEXT NOT NULL ,
  link_int TEXT NULL ,
  link_ext TEXT NULL ,
  tags JSON NULL,
  visibility VARCHAR(20) NOT NULL ,
  points INT NULL ,
  comments INT NULL ,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL ,
  deleted_at TIMESTAMP NULL
);

CREATE TABLE item_raw (
  item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hash TEXT NULL ,
  json JSON NULL ,
  text TEXT NULL ,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL
);

CREATE TABLE bucket (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  input JSONB NULL ,
  output JSONB NULL ,
  filter TEXT NULL ,
  is_enabled BOOL DEFAULT TRUE ,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL ,
  deleted_at TIMESTAMP NULL
);

CREATE TABLE category (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name character varying(20) NOT NULL,
  description character varying(255),
  is_visible boolean NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  upper_category_id integer
);

CREATE TABLE service (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  short_name VARCHAR(20) NOT NULL ,
  description TEXT NULL ,
  is_visible BOOL DEFAULT TRUE ,
  is_locked BOOL DEFAULT FALSE ,
  is_enabled BOOL DEFAULT TRUE ,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL ,
  deleted_at TIMESTAMP NULL
);

CREATE TABLE source (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  service_id UUID NOT NULL,
  name VARCHAR(30) NOT NULL,
  description VARCHAR(100),
  item_ordering_field VARCHAR(20) NOT NULL,
  allow_value BOOL NOT NULL,
  url VARCHAR(200) NOT NULL,
  is_public BOOL NOT NULL,
  is_locked BOOL NOT NULL,
  value_hint VARCHAR(100),
  value VARCHAR(100),
  do_auto_subscribe BOOL DEFAULT FALSE ,
  is_active BOOL NOT NULL ,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE subscription (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  value VARCHAR(100) NULL,
  last_refresh_at timestamp with time zone,
  due_refresh boolean NOT NULL,
  status character varying(15) NOT NULL,
  tokens_used integer,
  tokens_left integer,
  tokens_reset_at timestamp with time zone,
  is_active boolean NOT NULL,
  is_hidden boolean NOT NULL,
  overwritten_by_subscription_id integer,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
  profile_id integer,
  source_id integer NOT NULL
);

CREATE TABLE metric (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key character varying(200) NOT NULL ,
  value numeric(16,4) NOT NULL ,
  created_at timestamp with time zone NOT NULL ,
  updated_at timestamp with time zone NOT NULL
);

CREATE TABLE stat (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID NOT NULL ,
  day date NOT NULL,
  key character varying(30) NOT NULL,
  value integer NOT NULL,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,
);

CREATE TABLE token (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  service_id UUID NOT NULL ,
  handle VARCHAR(50) NULL ,
  friendly_name VARCHAR(50) NULL ,
  token TEXT NOT NULL ,
  token_secret TEXT NULL ,
  refresh_token TEXT NULL ,
  expiry TIMESTAMP NULL ,
  scope TEXT NULL ,
  is_active BOOL DEFAULT TRUE ,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL ,
  deleted_at TIMESTAMP NULL
);

-- +migrate Down

DROP TABLE item;
DROP TABLE item_raw;
DROP TABLE bucket;
DROP TABLE service;
DROP TABLE token;
