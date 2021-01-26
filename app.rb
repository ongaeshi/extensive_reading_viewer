require 'open-uri'
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  get_text("https://scrapbox.io/api/pages/ongaeshi/extensive_reading/text")
end

def get_text(url)
  URI.open(url) do |f|
    return f.read
  end
end