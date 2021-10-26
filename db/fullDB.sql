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

/*
 * Table Publisher
 *
 * List of publisers.
 */
CREATE TABLE tb_publisher (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null UNIQUE
);

/*
 * Table Language
 *
 * List of idioms.
 */
CREATE TABLE tb_language (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null UNIQUE
);

/*
 * Table File Types
 *
 * List of file types and its icons.
 */
CREATE TABLE tb_file_types (
  id INTEGER not null PRIMARY KEY autoincrement,
  name TEXT not null UNIQUE,
  icon_path TEXT
);

/*************************************************/

/* Author Tables */

/*
 * Table Author
 *
 * Bio data of literary work creators.
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
  link TEXT not null,
  PRIMARY KEY (author_fk, media_fk, link)
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
  sort_title TEXT not null,
  original_titla TEXT,
  original_publication_year TEXT
);

/*
 * Weak entity to relate the author and his/hers books.
 */
CREATE TABLE tb_title_author (
  title_fk INTEGER not null REFERENCES tb_title(id),
  author_fk INTEGER not null REFERENCES tb_author(id),
  role TEXT,
  PRIMARY KEY (title_fk, author_fk)
) WITHOUT ROWID;

/*
 * Table Edition
 *
 * Collection os editions from a title.
 */
CREATE TABLE tb_edition (
  id INTEGER not null PRIMARY KEY autoincrement,
  title_fk INTEGER not null REFERENCES tb_title(id),
  title TEXT not null,
  sort_title TEXT not null,
  edition TEXT,
  isbn TEXT,
  publisher_fk INTEGER REFERENCES tb_publisher(id),
  publication_year TEXT,
  pages INTEGER CHECK (pages >= 0),
  oficial_url TEXT,
  description TEXT,
  language_fk INTEGER REFERENCES tb_language(id),
  creation_date TEXT not null DEFAULT (date('now')),
  last_alteration_date TEXT DEFAULT (date('now'))
);

/*
 * Table e-book
 *
 * Represents an edition e-book file.
 */
CREATE TABLE tb_ebook (
  id INTEGER not null PRIMARY KEY autoincrement,
  path TEXT not null,
  file_name TEXT not null,
  format TEXT not null,
  edition_fk INTEGER not null REFERENCES tb_edition(id),
  UNIQUE (edition_fk, format)
)

/*******************************************************/

/* Picture Hierarchy */

/*
 * Table Picture
 *
 * Mother entity for all pictures.
 */
CREATE TABLE tb_picture (
  id INTEGER not null PRIMARY KEY autoincrement,
  path TEXT not null,
  type TEXT not null CHECK (type in ('AUTHOR', 'MEDIA', 'COVER')) -- selector field
);

/*
 * Table Author Picture
 *
 * Child entity for all author pictures.
 * Type = 'AUTHOR'
 */
CREATE TABLE tb_author_picture (
  id INTEGER not null PRIMARY KEY REFERENCES tb_picture(id),
  author_fk INTEGER not null REFERENCES tb_author(id)
) WITHOUT ROWID;

/*
 * Table Media Icon
 *
 * Child entity for all media icon pictures.
 * Type = 'MEDIA'
 */
CREATE TABLE tb_media_icon (
  id INTEGER not null PRIMARY KEY REFERENCES tb_picture(id),
  media_fk INTEGER not null REFERENCES tb_media(id)
) WITHOUT ROWID;

/*
 * Table Edition Cover
 *
 * Child entity for all editions cover.
 * Type = 'COVER'
 */
CREATE TABLE tb_edition_cover (
  id INTEGER not null PRIMARY KEY REFERENCES tb_picture(id),
  edition_fk INTEGER not null REFERENCES tb_edition(id)
) WITHOUT ROWID;

/********************************************************/