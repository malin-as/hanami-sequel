# Hanami::Sequel

This gem is designed to replace the `hanami-model` one in your
[Hanami](https://hanamirb.org/) project. It adds an equivalent set of database
commands to the `hanami` executable, and generates Sequel models.

Please note that using this gem could be considered bad practice with regards
to Hanami's architectural goals, as it does not provide any help to separate
the model into entities and repositories. On the other hand, it does nothing to
prevent it either.

## Installation

Follow the instructions for removing `hanami-model`:
[Use Your Own ORM](http://hanamirb.org/guides/1.1/models/use-your-own-orm/)

Add this line to your `config/environment.rb`:

```ruby
require "hamani/sequel/model"
```

Add this line to your application's Gemfile (adding the gem to the `plugins`
group ensures that the `hanami` executable is correctly extended):

```ruby
group :plugins do
  gem 'hanami-sequel', '~> 1.1.0'
end
```

And then execute:

    $ bundle

## Versioning

This gem's version is based on the major and minor versions of Hanami. For
`hanami-X.Y.Z`, use `hanami-sequel-X.Y.P`. This gem's patch version (denoted as
`P`) is independent from Hanami's patch version (denoted as `Z`).

## Configuration

As of now, the paths to migrations and models are hardcoded respectively to
`db/migrations/` and `lib/#{project_name}/models/`.

## Usage

All the commands start with the `sequel` argument:

```text
Commands:
  hanami sequel create
  hanami sequel drop
  hanami sequel install
  hanami sequel migrate [VERSION]
  hanami sequel migration NAME
  hanami sequel model NAME
  hanami sequel seed
```

#### Create a database table

    $ hanami sequel model NAME

Where `NAME` is the name of the model. This creates a database migration, a
Sequel model and a spec file.

#### Create a database migration

    $ hanami sequel migration NAME

Where `NAME` is an arbitrary name.

#### Create the database

    $ hanami sequel create

This command will fail in the `production` environment.

#### Migrate the database

    $ hanami sequel migrate [VERSION]

Where `VERSION` can be:

* "up" (default value), to do all the migrations, i.e. `hanami sequel migrate`
  or `hanami sequel migrate up`.
* "down", to undo all the migrations, i.e. `hanami sequel migrate down`.
* a timestamp, representing the first part of the target migration file. E.g.
  `hanami sequel migrate 20180201153930` to migrate to the database version as
  of 1st February 2018 at 15:39:30 (if a migration file starting with this
  value is found).

#### Seed the database

    $ hanami sequel seed

This command will look up your models for `Hanami:Sequel:Seed` class methods
used to import constants into your tables. If an error occurs, the whole `seed`
operation will be rolled back.

#### Drop the database

    $ hanami sequel drop

This command will fail in the `production` environment.

#### Install the database

    $ hanami sequel install

This command `drop`s, `create`s, `migrate`s, then `seed`s your database. It will fail in
the `production` environment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Known issues / To-do list

* hardcoded configuration values
* no tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/malin-as/hanami-sequel.
