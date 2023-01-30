require "open-uri"
require "nokogiri"

class Service
  attr_reader :key_word, :results

  def initialize(key_word)
    @key_word = key_word
  end

  def search
    # Scrap la page pour le résultat de la recherche
    url = "https://www.allrecipes.com/search?q=#{@key_word}"
    html = URI.open(url).read
    doc = Nokogiri::HTML.parse(html)
    @results = []
    doc.search(".card__title-text")[0..4].each { |element| results << element.text.strip }
    return @results
  end

  def scrap(index)
    # Réccupère l'url du résultat
    html = URI.open("https://www.allrecipes.com/search?q=#{@key_word}").read
    doc = Nokogiri::HTML.parse(html)
    url_css = ".comp.mntl-card-list-items.mntl-document-card.mntl-card.card.card--no-image"
    # On télécharge les resultats
    html = URI.open(doc.css(url_css)[index].attribute("href").text).read
    doc = Nokogiri::HTML.parse(html)
    # retourne les valeurs d'instance de Recipe
    name = @results[index]
    description = doc.css(".comp.type--dog.article-subheading").text.strip
    rating = doc.css("#mntl-recipe-review-bar__rating_2-0").text.strip
    prep_time = doc.css(".mntl-recipe-details__value")[3].text.strip
    return { name: name, description: description, rating: rating, prep_time: prep_time }
  end
end
