require 'sequel'

Sequel.connect(ENV.fetch('DATABASE_URL'))
