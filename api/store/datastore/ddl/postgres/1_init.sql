-- +migrate Up

CREATE TABLE item (
  id UUID PRIMARY KEY,
  item_id UUID NOT NULL,
  item_type VARCHAR(20) NOT NULL,
  media_type VARCHAR(20) NOT NULL ,
  service_name VARCHAR(20) NOT NULL,
  title TEXT NOT NULL ,
  description TEXT NOT NULL ,
  author VARCHAR(100) NOT NULL,
  author_media JSON NULL ,
  media JSON NULL ,
  location_name TEXT NULL ,
  location_point POINT NULL ,
  link TEXT NOT NULL ,
  link_int TEXT NULL ,
  link_ext TEXT NULL ,
  tags TEXT[] NULL,
  visibility VARCHAR(20),
  points INT NULL ,
  comments INT NULL ,
  channels UUID[] NULL,
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP NULL ,
  deleted_at TIMESTAMP NULL
);

-- +migrate Down

DROP TABLE item;