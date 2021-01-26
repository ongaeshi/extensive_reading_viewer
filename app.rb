require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  'Hello, extensive reading viewer!'
end
