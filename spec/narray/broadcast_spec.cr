require "../spec_helper"

describe Narray do
  describe ".broadcast_shapes" do
    it "returns the same shape when shapes are identical" do
      shape1 = [2, 3]
      shape2 = [2, 3]
      result = Narray.broadcast_shapes(shape1, shape2)

      result.should eq([2, 3])
    end

    it "broadcasts scalar to array shape" do
      shape1 = [2, 3]
      shape2 = [] of Int32
      result = Narray.broadcast_shapes(shape1, shape2)

      result.should eq([2, 3])
    end

    it "broadcasts 1D array to 2D array" do
      shape1 = [2, 3]
      shape2 = [3]
      result = Narray.broadcast_shapes(shape1, shape2)

      result.should eq([2, 3])
    end

    it "broadcasts when one dimension is 1" do
      shape1 = [2, 1]
      shape2 = [1, 3]
      result = Narray.broadcast_shapes(shape1, shape2)

      result.should eq([2, 3])
    end

    it "returns nil when shapes are incompatible" do
      shape1 = [2, 3]
      shape2 = [4, 5]
      result = Narray.broadcast_shapes(shape1, shape2)

      result.should be_nil
    end
  end

  describe ".broadcast" do
    it "returns the original array when shapes are identical" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      result = Narray.broadcast(arr, [2, 3])

      result.shape.should eq([2, 3])
      result.data.should eq([1, 2, 3, 4, 5, 6])
    end

    it "broadcasts 1D array to 2D array" do
      arr = Narray.array([3], [1, 2, 3])
      result = Narray.broadcast(arr, [2, 3])

      result.shape.should eq([2, 3])
      result.data.should eq([1, 2, 3, 1, 2, 3])
    end

    it "broadcasts when one dimension is 1" do
      arr = Narray.array([2, 1], [1, 2])
      result = Narray.broadcast(arr, [2, 3])

      result.shape.should eq([2, 3])
      result.data.should eq([1, 1, 1, 2, 2, 2])
    end

    it "raises an error when shapes are incompatible" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])

      expect_raises(ArgumentError, /Cannot broadcast/) do
        Narray.broadcast(arr, [4, 5])
      end
    end
  end

  describe "Array#broadcast_to" do
    it "broadcasts an array to a new shape" do
      arr = Narray.array([3], [1, 2, 3])
      result = arr.broadcast_to([2, 3])

      result.shape.should eq([2, 3])
      result.data.should eq([1, 2, 3, 1, 2, 3])
    end
  end

  describe "Array#+" do
    it "adds arrays with broadcasting" do
      a = Narray.array([2, 1], [1, 2])
      b = Narray.array([1, 3], [3, 4, 5])
      c = a + b

      c.shape.should eq([2, 3])
      c.data.should eq([4, 5, 6, 5, 6, 7])
    end
  end

  describe "Array#-" do
    it "subtracts arrays with broadcasting" do
      a = Narray.array([2, 1], [5, 10])
      b = Narray.array([1, 3], [1, 2, 3])
      c = a - b

      c.shape.should eq([2, 3])
      c.data.should eq([4, 3, 2, 9, 8, 7])
    end
  end

  describe "Array#*" do
    it "multiplies arrays with broadcasting" do
      a = Narray.array([2, 1], [2, 3])
      b = Narray.array([1, 3], [1, 2, 3])
      c = a * b

      c.shape.should eq([2, 3])
      c.data.should eq([2, 4, 6, 3, 6, 9])
    end
  end

  describe "Array#/" do
    it "divides arrays with broadcasting" do
      # Use Float64 arrays to ensure floating point division
      a = Narray.array([2, 1], [6.0, 9.0])
      b = Narray.array([1, 3], [1.0, 2.0, 3.0])
      c = a / b

      c.shape.should eq([2, 3])
      # Use be_close for floating point comparisons
      c.data[0].should eq(6)
      c.data[1].should eq(3)
      c.data[2].should eq(2)
      c.data[3].should eq(9)
      c.data[4].should be_close(4.5, 0.01)
      c.data[5].should eq(3)
    end
  end

  describe "Array#add!" do
    it "adds arrays with broadcasting in-place" do
      a = Narray.array([2, 1], [1, 2])
      b = Narray.array([1, 3], [3, 4, 5])
      result = a.add!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the array was modified correctly
      a.shape.should eq([2, 3])
      a.data.should eq([4, 5, 6, 5, 6, 7])
    end

    it "adds arrays with broadcasting in-place when result shape is the same" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([1, 3], [10, 20, 30])
      original_data = a.data.dup
      result = a.add!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the shape was not changed
      a.shape.should eq([2, 3])

      # Check that the data was modified correctly
      a.data.should eq([11, 22, 33, 14, 25, 36])

      # We're not checking object_id because the implementation might need to create a new array
      # The important thing is that the operation is logically in-place (same object)
      # and the data is correct
    end
  end

  describe "Array#subtract!" do
    it "subtracts arrays with broadcasting in-place" do
      a = Narray.array([2, 1], [5, 10])
      b = Narray.array([1, 3], [1, 2, 3])
      result = a.subtract!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the array was modified correctly
      a.shape.should eq([2, 3])
      a.data.should eq([4, 3, 2, 9, 8, 7])
    end
  end

  describe "Array#multiply!" do
    it "multiplies arrays with broadcasting in-place" do
      a = Narray.array([2, 1], [2, 3])
      b = Narray.array([1, 3], [1, 2, 3])
      result = a.multiply!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the array was modified correctly
      a.shape.should eq([2, 3])
      a.data.should eq([2, 4, 6, 3, 6, 9])
    end

    it "multiplies arrays with broadcasting in-place when result shape is the same" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([1, 3], [10, 20, 30])
      result = a.multiply!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the shape was not changed
      a.shape.should eq([2, 3])

      # Check that the data was modified correctly
      a.data.should eq([10, 40, 90, 40, 100, 180])
    end
  end

  describe "Array#divide!" do
    it "divides arrays with broadcasting in-place" do
      # Use Float64 arrays to ensure floating point division
      a = Narray.array([2, 1], [6.0, 9.0])
      b = Narray.array([1, 3], [1.0, 2.0, 3.0])
      result = a.divide!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the array was modified correctly
      a.shape.should eq([2, 3])

      # Use be_close for floating point comparisons
      a.data[0].should eq(6)
      a.data[1].should eq(3)
      a.data[2].should eq(2)
      a.data[3].should eq(9)
      a.data[4].should be_close(4.5, 0.01)
      a.data[5].should eq(3)
    end

    it "divides arrays with broadcasting in-place when result shape is the same" do
      # Use Float64 arrays to ensure floating point division
      a = Narray.array([2, 3], [10.0, 20.0, 30.0, 40.0, 50.0, 60.0])
      b = Narray.array([1, 3], [2.0, 4.0, 5.0])
      result = a.divide!(b)

      # Check that the result is the same object
      result.should be(a)

      # Check that the shape was not changed
      a.shape.should eq([2, 3])

      # Check that the data was modified correctly
      a.data[0].should eq(5)
      a.data[1].should eq(5)
      a.data[2].should eq(6)
      a.data[3].should eq(20)
      a.data[4].should be_close(12.5, 0.01)
      a.data[5].should eq(12)
    end
  end
end
