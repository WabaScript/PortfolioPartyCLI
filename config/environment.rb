require 'pry'
require 'bundler/setup'
require 'date'
require 'time'
require 'json'
require 'rest-client'

Bundler.require

require_rel '../config'
require_rel '../lib'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/development.sqlite"
)

# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger = nil