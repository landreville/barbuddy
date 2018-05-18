create table catalog (
  catalog varchar not null primary key check (catalog != '')
);

create table recipe_category (
  category varchar not null primary key check (category != '')
);

create table vessel(
  vessel varchar not null primary key check(vessel != '')
);

create table recipe (
  recipe_name varchar primary key check (recipe_name != ''),
  vessel varchar references vessel(vessel) on delete set null on update cascade,
  description varchar,
  catalog     varchar references catalog (catalog) on delete set null on update cascade,
  category    varchar references recipe_category on delete set null on update cascade,
  directions  text,
  story       text,
  active      boolean default false                              not null,
  inserted_at     timestamp with time zone default CURRENT_TIMESTAMP not null,
  photo_path  varchar
);
create index recipe_active_idx on recipe(active);

create table ingredient (
  ingredient_name        varchar primary key check (ingredient_name != ''),
  parent_ingredient_name varchar references ingredient(ingredient_name) on delete set null on update cascade,
  description            varchar,
  approved boolean not null default false
);
create index ingredient_approved_idx on ingredient(approved);
create index ingredient_parent_idx on ingredient(parent_ingredient_name);

create table substitute (
  ingredient_name     varchar references ingredient (ingredient_name) on update cascade not null,
  sub_ingredient_name varchar references ingredient (ingredient_name) on update cascade not null,
  ratio               numeric                                                           not null default 1,
  constraint ingredient_sub_pk primary key (ingredient_name, sub_ingredient_name)
);

create table unit (
  unit            varchar primary key check (unit != ''),
  plural          varchar,
  abbreviation    varchar,
  decilitre_ratio numeric
);

create table recipe_ingredient (
  recipe_name     varchar references recipe (recipe_name) on update cascade         not null,
  ingredient_name varchar references ingredient (ingredient_name) on update cascade not null,
  amount          numeric                                                           not null,
  unit            varchar references unit (unit) on delete set null on update cascade,
  garnish boolean not null default false,
  optional boolean not null default false,
  constraint recipe_ingredients_pk primary key (recipe_name, ingredient_name)
);

create table appuser (
  user_id     integer primary key generated by default as identity,
  email       varchar not null check (email != '') unique,
  password    varchar not null check (password != ''),
  info        jsonb   not null    default '{}',
  preferences jsonb   not null    default '{}',
  pantry jsonb not null default '[]',
  admin boolean not null default false
);

create table pantry (
  user_id         integer references appuser (user_id) on update cascade            not null,
  ingredient_name varchar references ingredient (ingredient_name) on update cascade not null,
  amount          numeric,
  unit            varchar references unit (unit) on delete set null on update cascade,
  constraint pantry_pk primary key (user_id, ingredient_name)
);

create table fav_recipe (
  user_id     integer references appuser (user_id) on update cascade    not null,
  recipe_name varchar references recipe (recipe_name) on update cascade not null,
  constraint fav_recipe_pk primary key (user_id, recipe_name)
);

create table fav_ingredient (
  user_id         integer references appuser (user_id) on update cascade            not null,
  ingredient_name varchar references ingredient (ingredient_name) on update cascade not null,
  constraint fav_ingredient_pk primary key (user_id, ingredient_name)
);

create table recipe_images(
  recipe_name varchar references recipe(recipe_name) on update cascade,
  image_type varchar not null check (image_type in ('main', 'thumbnail')),
  width numeric not null,
  height numeric not null,
  mime_type varchar not null,
  image bytea not null,
  constraint recipe_image_pk primary key (recipe_name, image_type)
);

GRANT SELECT, UPDATE, DELETE, INSERT ON ALL TABLES IN SCHEMA PUBLIC TO barbuddy;
