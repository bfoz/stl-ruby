require 'minitest/autorun'
require 'stl'

describe STL do
    it 'must read from a file' do
	stl = STL.read('test/fixtures/triangle.stl')
	stl.must_be_instance_of STL
	stl.faces.length.must_equal 1
    end
end
