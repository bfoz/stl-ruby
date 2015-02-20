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

	#   @return [Float]  The signed volume
	def signed_volume
 	    # math voodoo acording to:
 	    # http://stackoverflow.com/questions/1406029/how-to-calculate-the-volume-of-a-3d-mesh-object-the-surface-of-which-is-made-up
	    v321 = @points[2][0] * @points[1][1] * @points[0][2]
	    v231 = @points[1][0] * @points[2][1] * @points[0][2]
	    v312 = @points[2][0] * @points[0][1] * @points[1][2]
	    v132 = @points[0][0] * @points[2][1] * @points[1][2]
	    v213 = @points[1][0] * @points[0][1] * @points[2][2]
	    v123 = @points[0][0] * @points[1][1] * @points[2][2]
 	    (1.0/6.0)*(-v321 + v231 + v312 - v132 - v213 + v123)
	end
    end
end
