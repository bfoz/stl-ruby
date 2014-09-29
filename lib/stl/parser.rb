require 'geometry'

require_relative 'face'

class STL
    Point = Geometry::Point

    # http://en.wikipedia.org/wiki/STL_(file_format)
    class Parser
	# @param io [IO]	the stream to parse
	# @return [Array<Face>] An array of {Face}s
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
	# @param io [IO]	the stream to parse
	# @return [Array<Face>] An array of {Face}s
	def parse_ascii(io)
	    stack = []
	    faces = []
	    max = nil
	    min = nil
	    name = nil
	    io.each do |line|
		case line
		    when /solid (.*)/
			name = $1
		    when /facet normal\s+(\S+)\s+(\S+)\s+(\S+)/
			stack.push Vector[Float($1), Float($2), Float($3)]
		    when /vertex\s+(\S+)\s+(\S+)\s+(\S+)/
			v = Point[Float($1), Float($2), Float($3)]
			stack.push v

			# Update the statistics with the new vertex
			min = if min
			    Point[[min.x, v.x].min, [min.y, v.y].min, [min.z, v.z].min]
			else
			    v
			end

			max = if max
			    Point[[max.x, v.x].max, [max.y, v.y].max, [max.z, v.z].max]
			else
			    v
			end
		    when /endloop/
			normal, *vertices = stack.pop(4)
			faces.push Face.new(normal, *vertices)
		end
	    end
	    STL.new faces, min:min, max:max, name:name
	end

	# Parse a binary STL file, assuming that the header has already been read
	# @param io [IO]	the stream to parse
	# @return [Array<Face>] An array of {Face}s
	def parse_binary(io)
	    io.seek(80, IO::SEEK_SET)	# Skip the header bytes
	    count = io.read(4).unpack('V').first

	    faces = []
	    max = nil
	    min = nil
	    while not io.eof?
		normal, *vertices = io.read(50).unpack('F3F3F3F3x2').each_slice(3).to_a
		vertices.map! {|v| Point[v]}
		faces.push Face.new(Vector[*normal], *vertices)

		# Update the statistics with the new vertices
		vertices.each do |v|
		    v = Point[v]
		    min = if min
			Point[[min.x, v.x].min, [min.y, v.y].min, [min.z, v.z].min]
		    else
			v
		    end

		    max = if max
			Point[[max.x, v.x].max, [max.y, v.y].max, [max.z, v.z].max]
		    else
			v
		    end
		end
	    end
	    raise StandardError, "Unexpected end of file after #{faces.length} triangles" if faces.length != count

	    STL.new faces, min:min, max:max
	end
    end
end