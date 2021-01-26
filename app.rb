require 'open-uri'
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  text = get_text("https://scrapbox.io/api/pages/ongaeshi/extensive_reading/text")
  readings = parse_text(text)
  total = readings.reduce(0) {|r, i| r + i.word_count}
  unfinished = readings.find_all {|e| e.unfinish? }

<<EOS
#{total} words.<br>
#{readings.count} readings. (#{unfinished.count} unfinished)<br>
EOS
end

def get_text(url)
  URI.open(url) do |f|
    return f.read
  end
end

class Reading
  attr_reader :name, :word_count, :finish_date

  def initialize(line)
    data = line.split(" ")
    @name = data[0..-3].join(" ")
    @finish_date = data[-1]
    @word_count = unfinish? ? 0 : data[-2].to_i
    # TODO: DateTimeにパース
  end

  def unfinish?
    @finish_date == "??"
  end
end

def parse_text(src)
  src = src.split("\n")[1..-1]
  src.delete_if {|e| e =~ /^#/}
  src.map {|e| Reading.new(e) }
end