require 'geometry'

module STL
    # http://en.wikipedia.org/wiki/STL_(file_format)
    class Parser
	# @param io [IO]    the stream to parse
	# @return [Array]   An array of [Normal, Triangle] pairs
	def self.parse(io)
	    # A binary STL file has an 80 byte header that should never contain
	    #  the word 'solid'. The first non-whitespace characters of an ASCII
	    #  STL file should contain 'solid'.
	    if io.gets(80).include?('solid')
		io.rewind
		self.new.parse_ascii(io)
	    else
		self.new.parse_binary(io)
	    end
	end

	# Parse an ASCII STL file
	# @param io [IO]    the stream to parse
	# @return [Array]   An array of [Normal, Triangle] pairs
	def parse_ascii(io)
	    stack = []
	    triangles = []
	    io.each do |line|
		case line
		    when /solid (.*)/
			name = $1
		    when /facet normal\s+(\S+)\s+(\S+)\s+(\S+)/
			stack.push Vector[Float($1), Float($2), Float($3)]
		    when /vertex\s+(\S+)\s+(\S+)\s+(\S+)/
			stack.push Vector[Float($1), Float($2), Float($3)]
		    when /endloop/
			normal, *vertices = stack.pop(4)
			triangles.push [normal, Geometry::Triangle.new(*vertices)]
		end
	    end
	    triangles
	end

	# Parse a binary STL file, assuming that the header has already been read
	# @param io [IO]    the stream to parse
	# @return [Array]   An array of [Normal, Triangle] pairs
	def parse_binary(io)
	    count = io.read(4).unpack('V').first

	    faces = []
	    while not io.eof?
		normal, *vertices = io.read(50).unpack('F3F3F3F3x2').each_slice(3).to_a
		faces.push [Vector[*normal], Geometry::Triangle.new(*vertices)]
	    end
	    raise StandardError, "Unexpected end of file after #{faces.length} triangles" if faces.length != count

	    faces
	end
    end
end