require 'minitest/autorun'
require 'stl'

describe STL do
    it 'must read from a file' do
	stl = STL.read('test/fixtures/triangle.stl')
	stl.must_be_instance_of STL
    end

    it 'must recognize an ASCII file' do
	File.open 'test/fixtures/ascii_triangle.stl' do |f|
	    STL.ascii?(f).must_equal true
	end
    end

    it 'must recognize a binary file' do
	File.open 'test/fixtures/binary_triangle.stl' do |f|
	    STL.ascii?(f).must_equal false
	end
    end

    it 'must convert a file from ASCII to binary' do
	STL.convert('test/fixtures/ascii_triangle.stl')
	File.exist?('test/fixtures/ascii_triangle-binary.stl').must_equal true
	File.delete('test/fixtures/ascii_triangle-binary.stl')
    end

    it 'must convert a file from binary to ASCII' do
	STL.convert('test/fixtures/binary_triangle.stl')
	File.exist?('test/fixtures/binary_triangle-ascii.stl').must_equal true
	File.delete('test/fixtures/binary_triangle-ascii.stl')
    end

    it 'must process an ASCII file with NaN values' do
	stl = STL.read('test/fixtures/ascii_nan.stl')
	stl.must_be_instance_of STL
	stl.center.must_equal STL::Point[1.095131485, 23.618859999999998, 8.500191000000001]
    end

    describe 'when reading from an ascii file' do
	subject { STL.read('test/fixtures/triangle.stl') }

	it 'must have a center' do
	    subject.center.must_equal STL::Point[1.095131485, 23.618859999999998, 8.500191000000001]
	end

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

    describe 'when reading from a binary file' do
	subject { STL.read('test/fixtures/binary_triangle.stl') }

	it 'must have a center' do
	    subject.center.must_equal STL::Point[1.0951314717531204, 23.61885929107666, 8.50019097328186]
	end

	it 'must have faces' do
	    subject.faces.length.must_equal 1
	    subject.faces.first.must_be_instance_of STL::Face
	end

	it 'must have a minimum' do
	    subject.min.must_equal STL::Point[-0.06522902846336365, 23.565319061279297, 7.000381946563721]
	end

	it 'must have a maximum' do
	    subject.max.must_equal STL::Point[2.2554919719696045, 23.672399520874023, 10.0]
	end

	it 'must have a minmax' do
	    subject.minmax.must_equal [STL::Point[-0.06522902846336365, 23.565319061279297, 7.000381946563721], STL::Point[2.2554919719696045, 23.672399520874023, 10.0]]
	end
    end

    describe 'when scaling' do
	subject { STL.read('test/fixtures/binary_triangle.stl') }

	it 'must multiply all axes by a scaling factor' do
	    scaled_stl = subject.scale(2)
	    scaled_stl.must_be_kind_of STL
	    subject.faces.zip(scaled_stl.faces) do |a, b|
		a.points.zip(b.points) do |lhs, rhs|
		    rhs.must_equal lhs*2
		end
	    end
	end

	it 'must update the max attribute' do
	    subject.scale(2).max.must_equal subject.max*2
	end

	it 'must update the min attribute' do
	    subject.scale(2).min.must_equal subject.min*2
	end
    end

    describe 'when translating' do
	subject { STL.read('test/fixtures/binary_triangle.stl') }

	it 'must add an Array to all vertices' do
	    translated_stl = subject.translate([1,2,3])
	    translated_stl.must_be_kind_of STL
	    subject.faces.zip(translated_stl.faces) do |a,b|
		a.points.zip(b.points) do |lhs, rhs|
		    rhs.must_equal (lhs + [1,2,3])
		end
	    end
	end
    end
end
