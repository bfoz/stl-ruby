require_relative 'stl/parser'

class STL
    # @!attribute center
    #   @return [Point]  The center of the model's bounding box
    attr_reader :center

    # @!attribute faces
    #   @return [Array<Face>]  the list of faces
    attr_reader :faces

    # @!attribute max
    #   @return [Point]  the maximum extent of the solid
    attr_reader :max

    # @!attribute min
    #   @return [Point]  the minimum extent of the solid
    attr_reader :min

    # @!attribute name
    #   @return [String]  The name of the solid, or nil
    attr_accessor :name

    # Check the format of an IO stream that corresponds to an STL file
    # @param io	[IO]	An open {IO} stream
    # @return [Bool]	true if the STL file is ASCII formatted
    def self.ascii?(io)
	# A binary STL file has an 80 byte header that should never contain
	#  the word 'solid'. The first non-whitespace characters of an ASCII
	#  STL file should contain 'solid'.
	io.gets(80).include?('solid').tap { io.rewind }
    end

    # Convert an STL file encoding to the other type
    #  If the input file is ASCII, it will be converted to binary and written to
    #  the file '<original_filename>-binary.stl'. Likewise, if the file is
    #  binary, it will be converted and written to the file
    #  '<original_filename>-ascii.stl'.
    #  If the optional 'output' argument is provided, it will be used as the
    #  output filename.
    # @param filename [String]	The path to the file to convert
    # @param output   [String]	An optional path to write the converted file to
    def self.convert(filename, output=nil)
	File.open(filename, 'r') do |file|
	    if ascii?(file)
		output ||= filename.sub(/[-ascii]?\.stl/i, '-binary.stl')
		stl = STL::Parser.new.parse_ascii(file)
		write(output, stl.faces, :binary)
	    else
		output ||= filename.sub(/[-binary]?\.stl/i, '-ascii.stl')
		stl = STL::Parser.new.parse_binary(file)
		write(output, stl.faces, :ascii)
	    end
	end
    end

    # Read an STL file
    # @param filename [String]	The path to the file to read
    # @return [STL] the resulting {STL} object
    def self.read(filename)
	File.open(filename, 'r') {|f| STL::Parser.parse(f) }
    end

    # Write to an STL file
    # @param filename	[String]    The path to write to
    # @param faces	[Face]	    An array of faces to write
    # @param format	[Symbol]    Pass :ascii to write an ASCII formatted file, and :binary to write a binary file
    def self.write(filename, faces, format=:binary)
	File.open(filename, 'w') do |file|
	    if format == :ascii
		file.puts "solid #{name}"
		faces.each do |face|
		    file.puts "    facet normal %E %E %E" % [*face.normal]
		    file.puts "\touter loop"
		    face.points.each do |point|
			file.puts "\t    vertex %E %E %E" % [*point]
		    end
		    file.puts "\tendloop"
		    file.puts '    endfacet'
		end
		file.puts 'endsolid '
	    elsif format == :binary
		file.write 'STL Ruby'.ljust(80, "\0")	# A meager header
		file.write [faces.length].pack('V')	# The triangle count

		faces.each do |face|
		    file.write face.normal.to_a.pack("FFF")

		    face.points.each do |point|
			file.write point.to_a.pack("FFF")
		    end

		    file.write "\0\0"
		end
	    end
	end
    end

    def initialize(faces, min:nil, max:nil, name:nil)
	@center = (min + max)/2
	@faces = faces
	@max = max
	@min = min
	@name = name
    end

    # @!attribute minmax
    #   @return [Array]  the min and the max
    def minmax
	[min, max]
    end

    # Return a new {STL} object scaled by the given scaling factor
    def scale(factor)
	scaled_faces = faces.map do |face|
	    Face.new(face.normal, *(face.points.map {|v| v*factor}))
	end
	self.class.new scaled_faces, min:(min*factor), max:(max*factor)
    end

    # Write the entire model to the given file
    # @param filename   [String]	The path to write to
    # @param format	    [Symbol]    Pass :ascii to write an ASCII formatted file, and :binary to write a binary file
    def write(filename, format=:binary)
	self.class.write(filename, faces, format)
    end
end