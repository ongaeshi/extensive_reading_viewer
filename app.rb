require "bundler/setup"
Bundler.require
require 'open-uri'
# require 'sinatra'
# require "sinatra/reloader" if development?

get '/' do
  text = get_text("https://scrapbox.io/api/pages/ongaeshi/extensive_reading/text")
  readings = parse_text(text)
  total = readings.reduce(0) {|r, i| r + i.word_count}

<<EOS
#{total} words.<br>
#{readings.count} readings.<br>
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
    @word_count = data[-2].to_i
    @finish_date = data[-1]  
    # TODO: DateTimeにパース
    # TODO: ??のときは未読扱いにする
  end
end

def parse_text(src)
  # 行頭の#はコメント扱いにしてスキップ
  src = src.split("\n")[1..-1]
  src.map {|e| Reading.new(e) }
end