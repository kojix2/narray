require "../spec_helper"

describe Narray do
  describe "Array#+" do
    it "adds two arrays element-wise" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([2, 2], [5, 6, 7, 8])
      c = a + b

      c.shape.should eq([2, 2])
      c.data.should eq([6, 8, 10, 12])
    end

    it "adds a scalar to an array" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = a + 5

      b.shape.should eq([2, 2])
      b.data.should eq([6, 7, 8, 9])
    end

    it "raises an error when adding arrays with different shapes" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([3, 2], [5, 6, 7, 8, 9, 10])

      expect_raises(ArgumentError, /Cannot add arrays with different shapes/) do
        a + b
      end
    end
  end

  describe "Array#-" do
    it "subtracts two arrays element-wise" do
      a = Narray.array([2, 2], [5, 6, 7, 8])
      b = Narray.array([2, 2], [1, 2, 3, 4])
      c = a - b

      c.shape.should eq([2, 2])
      c.data.should eq([4, 4, 4, 4])
    end

    it "subtracts a scalar from an array" do
      a = Narray.array([2, 2], [5, 6, 7, 8])
      b = a - 3

      b.shape.should eq([2, 2])
      b.data.should eq([2, 3, 4, 5])
    end
  end

  describe "Array#*" do
    it "multiplies two arrays element-wise" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([2, 2], [5, 6, 7, 8])
      c = a * b

      c.shape.should eq([2, 2])
      c.data.should eq([5, 12, 21, 32])
    end

    it "multiplies an array by a scalar" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = a * 2

      b.shape.should eq([2, 2])
      b.data.should eq([2, 4, 6, 8])
    end
  end

  describe "Array#/" do
    it "divides two arrays element-wise" do
      a = Narray.array([2, 2], [10, 12, 14, 16])
      b = Narray.array([2, 2], [2, 3, 2, 4])
      c = a / b

      c.shape.should eq([2, 2])
      c.data.should eq([5, 4, 7, 4])
    end

    it "divides an array by a scalar" do
      a = Narray.array([2, 2], [2, 4, 6, 8])
      b = a / 2

      b.shape.should eq([2, 2])
      b.data.should eq([1, 2, 3, 4])
    end
  end

  describe "Array#-@" do
    it "negates an array" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = -a

      b.shape.should eq([2, 2])
      b.data.should eq([-1, -2, -3, -4])
    end
  end

  describe "Array#sum" do
    it "returns the sum of all elements" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      a.sum.should eq(10)
    end
  end

  describe "Array#mean" do
    it "returns the mean of all elements" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      a.mean.should eq(2.5)
    end
  end

  describe "Array#min" do
    it "returns the minimum value" do
      a = Narray.array([2, 2], [3, 1, 4, 2])
      a.min.should eq(1)
    end
  end

  describe "Array#max" do
    it "returns the maximum value" do
      a = Narray.array([2, 2], [3, 1, 4, 2])
      a.max.should eq(4)
    end
  end

  describe "Array#std" do
    it "returns the standard deviation" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      a.std.should be_close(1.118, 0.001)
    end
  end

  describe ".dot" do
    it "computes the dot product of two matrices" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([3, 2], [7, 8, 9, 10, 11, 12])
      c = Narray.dot(a, b)

      c.shape.should eq([2, 2])
      c.data.should eq([58, 64, 139, 154])
    end

    it "raises an error when dimensions don't match" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([2, 2], [7, 8, 9, 10])

      expect_raises(ArgumentError, /Inner dimensions must match/) do
        Narray.dot(a, b)
      end
    end
  end

  describe ".matmul" do
    it "computes the matrix multiplication" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([3, 2], [7, 8, 9, 10, 11, 12])
      c = Narray.matmul(a, b)

      c.shape.should eq([2, 2])
      c.data.should eq([58, 64, 139, 154])
    end
  end
end
