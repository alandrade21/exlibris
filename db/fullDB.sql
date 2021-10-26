/* Miscelaneous Data */

/*
 * Table Country
 *
 * List of countries.
 */
CREATE TABLE tb_country (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null UNIQUE
);

/*
 * Table Media
 *
 * List of media channels, as social networks, blogs, etc.
 */
CREATE TABLE tb_media (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null UNIQUE
);

/*
 * Table Tag
 *
 * List of tag names.
 */
CREATE TABLE tb_tag (
  id INTEGER not null PRIMARY KEY autoincrement,
  tag TEXT not null UNIQUE,
  color TEXT -- color hex code
);

/*************************************************/

/* Author Tables */

/*
 * Table Author
 *
 * Bio data of leterary work creators.
 */
CREATE TABLE tb_author (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null,
  sort_name TEXT not null,
  birth_date TEXT, -- date
  death_date TEXT, -- date
  birth_country_fk INTEGER REFERENCES tb_country(id),
  birth_city TEXT,
  biography TEXT
);

/*
 * Weak entity to relate the author and his/hers media channels.
 */
CREATE TABLE tb_author_media (
  author_fk INTEGER not null REFERENCES tb_author(id),
  media_fk INTEGER not null REFERENCES tb_media(id),
  PRIMARY KEY (author_fk, media_fk)
) WITHOUT ROWID;

/*
 * Weak entity to relate the author and his/hers tags.
 */
CREATE TABLE tb_author_tag (
  author_fk INTEGER not null REFERENCES tb_author(id),
  tag_fk INTEGER not null REFERENCES tb_tag(id),
  PRIMARY KEY (author_fk, tag_fk)
) WITHOUT ROWID;

/*************************************************************/

/* Book Tables */

/*
 * Table Title
 *
 * Agregates the leterary work metadata.
 */
CREATE TABLE tb_title (
  id INTEGER not null PRIMARY KEY autoincrement,
  title TEXT not null,
  author_fk INTEGER REFERENCES tb_author(id),
);

/* Picture Hierarchy */

/*
 * Table Picture
 *
 * Mother entity for all pictures.
 */
CREATE TABLE tb_picture (
  id INTEGER not null PRIMARY KEY autoincrement,
  picture_path TEXT not null,
  type TEXT not null CHECK (type in ('AUTHOR', 'MEDIA')) -- selector field
);

/*
 * Table Author Picture
 *
 * Child entity for all author pictures.
 */
CREATE TABLE tb_author_picture (
  id INTEGER not null PRIMARY KEY REFERENCES tb_picture(id),
  author_fk INTEGER not null REFERENCES tb_author(id)
) WITHOUT ROWID;

/*
 * Table Media Icon
 *
 * Child entity for all media icon pictures.
 */
CREATE TABLE tb_media_icon (
  id INTEGER not null PRIMARY KEY REFERENCES tb_picture(id),
  media_fk INTEGER not null REFERENCES tb_media(id)
) WITHOUT ROWID;

/********************************************************/