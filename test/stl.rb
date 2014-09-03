require 'minitest/autorun'
require 'stl'

describe STL do
    it 'must read from a file' do
	stl = STL.read('test/fixtures/triangle.stl')
	stl.must_be_instance_of STL
    end

    describe 'when reading from a file' do
	subject { STL.read('test/fixtures/triangle.stl') }

	it 'must have a name' do
	    subject.name.must_equal 'Triangle'
	end

	it 'must have faces' do
	    subject.faces.length.must_equal 1
	    subject.faces.first.must_be_instance_of STL::Face
	end

	it 'must have a minimum' do
	    subject.min.must_equal STL::Point[-0.06522903, 23.56532, 7.000382]
	end

	it 'must have a maximum' do
	    subject.max.must_equal STL::Point[2.255492, 23.6724, 10]
	end

	it 'must have a minmax' do
	    subject.minmax.must_equal [STL::Point[-0.06522903, 23.56532, 7.000382], STL::Point[2.255492, 23.6724, 10]]
	end
    end
end
