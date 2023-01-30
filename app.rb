require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

COOKBOOK = Cookbook.new("recipes.csv")

get "/" do
  @recipes = COOKBOOK.all
  erb :index
end

get "/menu" do
  erb :menu
end

get "/add" do
  @name = params[:name]
  @description = params[:description]
  @prep_time = params[:prep_time]
  @rating = params[:rating]
  erb :add
end

after do
  unless @name == "" && @description == ""
  @recipe = Recipe.new(@name, @description, @rating, @prep_time)
  COOKBOOK.create(@recipe)
end
