# Guard::Go

Guard Go runs go programs and restart when file changes

## Installation

### For gophers

You must have a working Ruby installation, then:

    $ gem install bundler
    $ cd /your/project/dir
    $ bundle init

### For gophers and Rubysts

Add this line to your application's Gemfile:

    gem 'guard-go'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-go

## Usage

Read Guard usage https://github.com/guard/guard#usage

    $ bundle exec guard init go

This will create your Guardfile.

Edit this and configure your application file name and desired options.

Options defaults to:

    :server      => 'app.go' # Go source file to run
    :test        => false    # To run go test instead of the app.
    :build_only  => false    # To build instead of run.
    :args        => []       # Parameters, e.g. :args => 420, :args => [420, 120], :args => ["one", "two"]
    :cmd         => 'go'     # Name of the Go commandline tool

    $ bundle exec guard
