# Guard::Go

Guard Go runs go programs and restart when file changes

## Installation

# For gophers

You must have a working Ruby installation, then:

   $ gem install bundler
   $ cd /your/project/dir 
   $ bundle init

# For gophers and Rubysts

Add this line to your application's Gemfile:

    gem 'guard-go'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-go

## Usage

	$ bundle exec guard init go

This will create your Guardfile. Edit it and configure your application file name (defaults to app.go)

  $ bundle exec guard
