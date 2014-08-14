require 'geometry'

module STL
    class Parser
	# @param io [IO]    the stream to parse
	def self.parse(io)
	    self.new.parse(io)
	end

	# @param io [IO]    the stream to parse
	# @return [Array]   An array of [Normal, Triangle] pairs
	def parse(io)
	    stack = []
	    triangles = []
	    io.each do |line|
		case line
		    when /solid (.*)/
			name = $1
		    when /facet normal (.+) (.+) (.+)/
			stack.push Vector[Float($1), Float($2), Float($3)]
		    when /vertex (.+) (.+) (.+)/
			stack.push Vector[Float($1), Float($2), Float($3)]
		    when /endloop/
			triangles.push [stack.pop, Geometry::Triangle.new(*stack.pop(3))]
		end
	    end
	    triangles
	end
    end
end