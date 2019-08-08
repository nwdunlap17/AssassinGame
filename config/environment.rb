require 'bundler/setup'
require 'sinatra/activerecord'
require 'require_all'
require 'bundler'

Bundler.require

ActiveRecord::Base.establish_connection(
   :adapter => "sqlite3",
   :database => "./db/database.db"
)

require_all 'lib'