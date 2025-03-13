require "./spec_helper"

describe Narray do
  describe ".zeros" do
    it "creates an array filled with zeros" do
      arr = Narray.zeros([2, 3])
      arr.shape.should eq([2, 3])
      arr.ndim.should eq(2)
      arr.size.should eq(6)
      arr.data.all? { |x| x == 0.0 }.should be_true
    end

    it "creates an array with the specified data type" do
      arr = Narray.zeros([2, 2], Int32)
      arr.data.all? { |x| x == 0 }.should eq(true)
      arr.data[0].should be_a(Int32)
    end
  end

  describe ".ones" do
    it "creates an array filled with ones" do
      arr = Narray.ones([2, 3])
      arr.shape.should eq([2, 3])
      arr.ndim.should eq(2)
      arr.size.should eq(6)
      arr.data.all? { |x| x == 1.0 }.should be_true
    end

    it "creates an array with the specified data type" do
      arr = Narray.ones([2, 2], Int32)
      arr.data.all? { |x| x == 1 }.should be_true
      arr.data[0].should be_a(Int32)
    end
  end

  describe ".arange" do
    it "creates an array with evenly spaced values" do
      arr = Narray.arange(0, 10, 2)
      arr.shape.should eq([5])
      arr.ndim.should eq(1)
      arr.size.should eq(5)
      arr.data.should eq([0, 2, 4, 6, 8])
    end

    it "creates an array with the specified data type" do
      arr = Narray.arange(0, 5, 1_f64, Float64)
      arr.data.should eq([0.0, 1.0, 2.0, 3.0, 4.0])
      arr.data[0].should be_a(Float64)
    end
  end

  describe ".linspace" do
    it "creates an array with evenly spaced values over an interval" do
      arr = Narray.linspace(0, 1, 5)
      arr.shape.should eq([5])
      arr.ndim.should eq(1)
      arr.size.should eq(5)

      expected = [0.0, 0.25, 0.5, 0.75, 1.0]
      arr.data.size.should eq(expected.size)
      arr.data.each_with_index do |val, i|
        val.should be_close(expected[i], 1e-10)
      end
    end

    it "creates an array with the specified data type" do
      arr = Narray.linspace(0, 1, 3, Float32)
      arr.data[0].should be_a(Float32)
    end
  end

  describe ".array" do
    it "creates an array with the given shape and data" do
      arr = Narray.array([2, 2], [1, 2, 3, 4])
      arr.shape.should eq([2, 2])
      arr.ndim.should eq(2)
      arr.size.should eq(4)
      arr.data.should eq([1, 2, 3, 4])
    end

    it "raises an error if data size doesn't match shape" do
      expect_raises(ArgumentError) do
        Narray.array([2, 2], [1, 2, 3])
      end
    end
  end

  describe "#[]" do
    it "returns the element at the given indices" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      arr[[0, 0]].should eq(1)
      arr[[0, 1]].should eq(2)
      arr[[0, 2]].should eq(3)
      arr[[1, 0]].should eq(4)
      arr[[1, 1]].should eq(5)
      arr[[1, 2]].should eq(6)
    end

    it "raises an error for invalid indices" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])

      expect_raises(IndexError, /Wrong number of indices/) do
        arr[[0]]
      end

      expect_raises(IndexError, /out of bounds/) do
        arr[[2, 0]]
      end

      expect_raises(IndexError, /out of bounds/) do
        arr[[0, 3]]
      end
    end
  end

  describe "#[]=" do
    it "sets the element at the given indices" do
      arr = Narray.zeros([2, 3], Int32)
      arr[[0, 0]] = 1
      arr[[0, 1]] = 2
      arr[[1, 2]] = 3

      arr.data.should eq([1, 2, 0, 0, 0, 3])
    end

    it "raises an error for invalid indices" do
      arr = Narray.zeros([2, 3], Int32)

      expect_raises(IndexError, /Wrong number of indices/) do
        arr[[0]] = 1
      end

      expect_raises(IndexError, /out of bounds/) do
        arr[[2, 0]] = 1
      end

      expect_raises(IndexError, /out of bounds/) do
        arr[[0, 3]] = 1
      end
    end
  end

  describe "#to_s" do
    it "returns a string representation of the array" do
      arr = Narray.array([2, 2], [1, 2, 3, 4])
      arr.to_s.should eq("Narray.array([2, 2], [1, 2, 3, 4])")
    end
  end
end
