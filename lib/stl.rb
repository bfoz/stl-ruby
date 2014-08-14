require_relative 'stl/parser'

module STL
    # Read an STL file
    # @param filename [String]	The path to the file to read
    # @return [STL] the resulting {STL} object
    def self.read(filename)
	File.open(filename, 'r') {|f| STL::Parser.parse(f) }
    end
end
