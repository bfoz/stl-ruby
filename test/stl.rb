require 'minitest/autorun'
require 'stl'

describe STL do
    it 'must read from a file' do
	stl = STL.read('test/fixtures/triangle.stl')
	stl.must_be_instance_of Array
    end
end
