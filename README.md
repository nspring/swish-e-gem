# Readme for Swish-e Ruby Bindings

## Example usage
```ruby
 require "swishe"
 sw=SwishE.new("swishe-index")
 sw.query("searchstring").each do |result|
   puts result.docpath
   puts result.rank
   # .... 
 end
 sw.close
```

```ruby
 require "swishe"
 sw=SwishE.new("swishe-index")
 sw.search({"query" => "This is","order" => "swishdocsize asc","limit" => 1}).each do |result|
   puts result.docpath
   puts result.rank
   # .... 
 end
 sw.close
```

## Installing the bindings

You have two choices installing the bindings. First, use the gem command, such as

    gem install swishe
 
in case the gem command doesn't find the Swish-e C-library you might need to supply the path
to the library on the gem command line, for example:
 
    gem install swishe -- --with-swishe-dir=/opt/swishe/2.4.3/

The other way to install the ruby bindings for Swish-e would be to download the source file
and run setup.rb manually:
 
    ruby setup.rb all
 
and again, if your system doesn't find the Swish-e library, you need to supply those:
 
    ruby setup.rb all --  --with-swishe-dir=/opt/swishe/2.4.3/
 
Needles to say that you need to change the path according to your system requirements.

## Bundler

In your Gemfile, add:

    gem 'swishe', :git => 'git://github.com/nspring/swish-e-gem.git'

Of course, you'll need swish-e with development headers
installed `brew install swish-e` or `apt-get install
swish-e-dev`.

## Other Stuff
Author:: Patrick Gundlach <patrick <at> gundla.ch>

License::  Copyright (c) 2006 Patrick Gundlach.
           Released under the terms of the MIT license.  See the file MIT-LICENSE

Reluctant maintainer:: Neil Spring 
