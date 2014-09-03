# STL

Read, write and manipulate both ASCII and binary [STL files](http://en.wikipedia.org/wiki/STL_(file_format))

## Installation

Add this line to your application's Gemfile:

    gem 'stl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stl

## Usage

```ruby
require 'stl'

stl = STL.read('my_awesome.stl')
stl.faces			    # => [Face, ...]
```

License
-------

Copyright 2014 Brandon Fosdick <bfoz@bfoz.net> and released under the BSD license.
