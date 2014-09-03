class STL
    class Face
	# @!attribute normal
	#   @return [Vector]  The surface normal for the {Face}, or nil
	attr_reader :normal

	# @!attribute points
	#   @return [Array<Point>]  The vertices
	attr_reader :points
	alias :vertices :points

	# @param normal	    [Vector]    the surface normal
	# @param vertices   [Array]	the verticies
	def initialize(normal, *vertices)
	    @normal = normal
	    @points = vertices
	end
    end
end
