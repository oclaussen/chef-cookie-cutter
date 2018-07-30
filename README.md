# Chef Cookie Cutter

[![Gem](https://img.shields.io/gem/v/chef-cookie_cutter.svg?style=plastic)][gem]
[![Travis](https://img.shields.io/travis/oclaussen/chef-cookie-cutter.svg?style=plastic)][travis]

[gem]: https://rubygems.org/gems/chef-cookie_cutter
[travis]: http://travis-ci.org/oclaussen/chef-cookie-cutter

Cookie Cutter is a Ruby Gem / Chef Cookbook combination, that extends the Chef
cookbook DSL with new features and possibilities.

## Disclaimer

This gem is mostly the result of me srewing around with Chef and Ruby
metaprogramming. It's motivation is purely educational and never intended to end
up in anything production critical.

Many of the features are questionable hacks. The documantation is crap, tests
are almost nonexistent and I don't have a proper release workflow set up yet.
As long as I am the only one using this, I will haphazardly introduce breaking
changes, and add or remove features on a whim.

I hope to bring this into a more stable, documented and tested state over time.
Until then, please do not use this gem for anything important. You are invited
to play around with it for small, personal projects. But if you find something
you really want, you might be better off by just copying the respective code
over to your own library.

## Usage

### As a cookbook

Just add a dependency to `cookie-cutter` cookbook.

In your `Berksfile`:

```ruby
cookbook 'cookie-cutter', github: 'oclaussen/chef-cookie-cutter.git', rel: 'cookbook'
```

And in your `metadata.rb`

```ruby
depends 'cookie-cutter'
```

### As a gem

Alternatively, you can also install the Cookie Cutter as a ruby gem:

```
gem install chef-cookie_cutter
```

Then you can require it in your cookbook:

```ruby
require 'chef/cookie_cutter'
```

If you want to use only some of the provided features, you can require each
submodule individually, e.g.:

```ruby
require 'chef/cookie_cutter/run_state'
require 'chef/cookie_cutter/collect_property'
```

The downside of using the Cookie Cutter as a gem is that you have to make sure
the gem is installed before the cookbooks are compiled. There are several
options to achive this, for example by installing the gem during the Chef
bootstrap process. Or by storing the gem directly in your cookbook, somewhere 
under `files/default`, and adding it to the load path in a library file.
