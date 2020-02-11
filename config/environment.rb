require 'pry'
require 'bundler/setup'
require 'date'
require 'rest-client'
require 'json'
Bundler.require
require_rel '../config'
require_rel '../lib'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/development.sqlite"
)