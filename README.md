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

Add this line to your application's Gemfile (adding the gem to the `plugins`
group ensures that the `hanami` executable is correctly extended):

```ruby
group :plugins do
  gem 'hanami-sequel'
end
```

And then execute:

    $ bundle

## Usage

All the commands start with the `sequel` argument:

```text
Commands:
  hanami sequel create
  hanami sequel drop
  hanami sequel migrate [VERSION]
  hanami sequel migration NAME
  hanami sequel model NAME
```

### Create your database

Create your database with:

```text
  hanami sequel create
```

This command will fail in the `production` environment.

### Drop your database

Drop your database with:

```text
  hanami sequel drop
```

This command will fail in the `production` environment.

### Migrate your database

Migrate your database with:

```text
  hanami sequel migrate [VERSION]
```

Where `VERSION` can be:

* "up" (default value), to do all the migrations, i.e. `hanami sequel migrate`
  or `hanami sequel migrate up`.
* "down", to undo all the migrations, i.e. `hanami sequel migrate down`.
* an integer/timestamp, representing the first part of the target migration
  file. E.g. `hanami sequel migrate 20180201153930` to migrate to the
  database version as of 1st February 2018 at 15:39:30 (if a migration file
  starting with this value is found).
* an offset, representing how many migrations to do (positive offset) or to
  undo (negative offset) from the current state. E.g. `hanami sequel migrate +2`
  to do 2 more migrations, `hanami sequel migrate -1` to undo the latest
  migration.

### Create a database migration

Create a migration with:

```text
  hanami sequel migration NAME
```

Where `NAME` is an arbitrary name.

### Create a database table

Create a new table with:

```text
  hanami sequel model NAME
```

Where `NAME` is the name of the model. This creates a database migration and a
corresponding Sequel model.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/malin-as/hanami-sequel.
