require "csv"
require_relative "recipe"

class Cookbook
  attr_reader :recipes

  def initialize(csv_file_path)
    @recipes = []
    @csv = csv_file_path
    CSV.foreach(@csv) { |row| @recipes << Recipe.new(row[0], row[1], row[2], row[3]) }
  end

  def all
    @recipes
  end

  def create(recipe)
    @recipes << recipe
    CSV.open(@csv, "wb") do |csv|
      @recipes.each { |item| csv << [item.name, item.description, item.rating, item.prep_time] }
    end
  end

  def destroy(recipe_index)
    @recipes.delete_at(recipe_index)
    CSV.open(@csv, "wb") do |csv|
      @recipes.each { |item| csv << [item.name, item.description, item.rating, item.prep_time] }
    end
  end
end
