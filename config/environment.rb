ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])



require 'pry'
require 'csv'
require 'date'
require_all 'app'