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

To convert an ASCII STL file to a binary file:

```ruby
STL.read('ascii.stl').write('binary.stl', :binary)
```

Writing binaries files is actually the default, so you can also leave off the last argument to write, if you want.

```ruby
STL.read('ascii.stl').write('binary.stl')
```

You can also convert binary files to ASCII.

```ruby
STL.read('binary.stl').write('ascii.stl', :ascii)
```

### Converting between ASCII and binary

There's an easier way to do a format conversion, and it doesn't require that you
know the original format. Simply use the `convert` method, and the format of the
input will be toggled (ASCII to binary, or binary to ASCII). The converted
filename will be the same as the original, but with '-ascii' or '-binary'
appended, as appropriate.

```ruby
STL.convert('ascii.stl')	# => ascii-binary.stl
STL.convert('binary.stl')	# => binary-ascii.stl
```

License
-------

Copyright 2014 Brandon Fosdick <bfoz@bfoz.net> and released under the BSD license.
