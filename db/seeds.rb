# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'
require 'faker'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'

contents = JSON.parse(URI.open(url).read)

Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

contents['drinks'].each do |drink|
  Ingredient.create(name: drink['strIngredient1'])
end

def seed_cocktail
  cocktail_name = Faker::Hipster.words(number: rand(1..3)).join(' ')
  cocktail = Cocktail.new(name: "The #{cocktail_name.titleize}")
  avail_ingredients = Ingredient.ids
  rand(3..5).times do
    desc = ['1/2', '1/4', '1', '2', '3'].sample + ' ' + %w[tsp tbsp oz].sample
    dose = Dose.new(description: desc)
    dose.cocktail = cocktail
    ingredient = avail_ingredients.sample
    avail_ingredients.delete(ingredient)
    dose.ingredient = Ingredient.find_by_id(ingredient)
    dose.save
  end
end

20.times do
  seed_cocktail
end
