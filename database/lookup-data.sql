insert into recipe_category(category)
values ('Sour'), ('Spirit-Forward'), ('Highball'), ('Hot'), ('Flip'), ('Tropical');

insert into catalog(catalog)
values ('IBA');

insert into vessel(vessel)
values ('Rocks'), ('Old Fashioned'), ('Cocktail'), ('Coupe'), ('Martini'), ('Shot'),
  ('Highball'), ('Collins'), ('Flute'), ('Copper Mug'), ('Snifter'), ('Cordial'),
  ('Goblet'), ('Hurricane'), ('Clear Plastic Bag');

insert into unit(unit, plural, abbreviation, decilitre_ratio)
values
  ('Ounce', 'Ounces', 'oz', 30),
  ('Dash', 'Dashes', null, 0.01),
  ('Splash', 'Splashes', null, 0.03),
  ('Teaspoon', 'Teaspoons', 'tsp', 0.05),
  ('Tablespoon', 'Tablespoons', 'tbl', 0.15),
  ('Decilitre', 'Decilitres', 'dl', 1),
  ('Slice', 'Slices', null, null),
  ('Leaf', 'Leaves', null, null),
  ('Sprig', 'Sprigs', null, null),
  ('Cube', 'Cubes', null, null),
  ('Drop', 'Drops', null, 0.005);

insert into ingredient(ingredient_name)
values 
  ('Absinthe'),
  ('Amaretto'),
  ('Angostura Bitters'),
  ('Apricot Brandy'),
  ('Benedictine'),
  ('Blackberry Liqueur'),
  ('Bourbon'),
  ('Brandy'),
  ('Cachaca'),
  ('Calvados'),
  ('Campari'),
  ('Celery Salt'),
  ('Celery Stalk'),
  ('Champagne'),
  ('Cherry Liqueur'),
  ('Clamato Juice'),
  ('Cocchi Americano'),
  ('Coconut Cream'),
  ('Coffee Liqueur'),
  ('Cognac'),
  ('Cointreau'),
  ('Cola'),
  ('Cranberry Juice'),
  ('Cream'),
  ('Creme de Cacao'),
  ('Creme de Menthe'),
  ('Creme de Violette'),
  ('Curacao'),
  ('Dark Rum'),
  ('Drambuie'),
  ('Dry Vermouth'),
  ('Egg White'),
  ('Egg Yolk'),
  ('Galliano'),
  ('Gin'),
  ('Old Tom Gin'),
  ('Ginger Ale'),
  ('Ginger Beer'),
  ('Gomme Syrup'),
  ('Grand Marnier'),
  ('Grapefruit Juice'),
  ('Grenadine'),
  ('Ground Pepper'),
  ('Honey'),
  ('Hot Sauce'),
  ('Irish Cream'),
  ('Kahlua'),
  ('Kirsch'),
  ('Lemon Juice'),
  ('Lemon'),
  ('Lime Juice'),
  ('Lime Wedge'),
  ('Lime'),
  ('Maraschino Cherry'),
  ('Maraschino Liqueur'),
  ('Mint'),
  ('Nutmeg'),
  ('Olive'),
  ('Orange Bitters'),
  ('Orange Flower Water'),
  ('Orange Juice'),
  ('Orange Soda'),
  ('Orange'),
  ('Orgeat'),
  ('Peach Bitters'),
  ('Peach Puree'),
  ('Peach Schnapps'),
  ('Peychaud''s Bitters'),
  ('Pico de Gallo'),
  ('Pineapple Juice'),
  ('Pisco'),
  ('Port'),
  ('Prosecco'),
  ('Raspberry Syrup'),
  ('Rye Whiskey'),
  ('Scotch'),
  ('Simple Syrup'),
  ('Soda'),
  ('Strawberry Syrup'),
  ('Sugar Cube'),
  ('Sugar'),
  ('Sweet Vermouth'),
  ('Tequila'),
  ('Tomato Juice'),
  ('Triple Sec'),
  ('Vanilla'),
  ('Vodka'),
  ('Water'),
  ('Whiskey'),
  ('White Rum'),
  ('Worcestershire Sauce');

update ingredient set approved = true;

update ingredient
set parent_ingredient_name = 'Sugar'
where ingredient_name in ('Sugar Cube', 'Simple Syrup');

update ingredient
set parent_ingredient_name = 'Whiskey'
where ingredient_name in ('Bourbon', 'Rye Whiskey', 'Scotch');

update ingredient
set parent_ingredient_name = 'Brandy'
where ingredient_name = 'Cognac';

update ingredient
set parent_ingredient_name = 'Gin'
where ingredient_name = 'Old Tom Gin';

insert into substitute(ingredient_name, sub_ingredient_name, ratio)
values
  ('Cointreau', 'Triple Sec', 1),
  ('Triple Sec', 'Cointreau', 1),
  ('Prosecco', 'Champagne', 1),
  ('Champagne', 'Prosecco', 1);
