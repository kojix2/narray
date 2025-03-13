require "../spec_helper"

describe Narray do
  describe "Array#reshape" do
    it "reshapes a 1D array to 2D" do
      arr = Narray.arange(0, 6)
      reshaped = arr.reshape([2, 3])

      reshaped.shape.should eq([2, 3])
      reshaped.ndim.should eq(2)
      reshaped.size.should eq(6)
      reshaped.data.should eq([0, 1, 2, 3, 4, 5])
    end

    it "reshapes a 2D array to 1D" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      reshaped = arr.reshape([6])

      reshaped.shape.should eq([6])
      reshaped.ndim.should eq(1)
      reshaped.size.should eq(6)
      reshaped.data.should eq([1, 2, 3, 4, 5, 6])
    end

    it "raises an error if the new shape has a different number of elements" do
      arr = Narray.arange(0, 6)

      expect_raises(ArgumentError, /Cannot reshape/) do
        arr.reshape([2, 4])
      end
    end
  end

  describe "Array#transpose" do
    it "transposes a 1D array" do
      arr = Narray.arange(0, 3)
      transposed = arr.transpose

      transposed.shape.should eq([3])
      transposed.data.should eq([0, 1, 2])
    end

    it "transposes a 2D array" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      transposed = arr.transpose

      transposed.shape.should eq([3, 2])
      transposed.data.should eq([1, 4, 2, 5, 3, 6])
    end

    it "transposes a 3D array" do
      arr = Narray.array([2, 2, 2], [1, 2, 3, 4, 5, 6, 7, 8])
      transposed = arr.transpose

      transposed.shape.should eq([2, 2, 2])
      transposed.data.should eq([1, 5, 3, 7, 2, 6, 4, 8])
    end
  end

  describe ".concatenate" do
    it "concatenates 1D arrays along axis 0" do
      a = Narray.array([3], [1, 2, 3])
      b = Narray.array([3], [4, 5, 6])
      c = Narray.concatenate([a, b])

      c.shape.should eq([6])
      c.data.should eq([1, 2, 3, 4, 5, 6])
    end

    it "concatenates 2D arrays along axis 0" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([1, 3], [7, 8, 9])
      c = Narray.concatenate([a, b])

      c.shape.should eq([3, 3])
      c.data.should eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
    end

    it "concatenates 2D arrays along axis 1" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([2, 3], [5, 6, 7, 8, 9, 10])
      c = Narray.concatenate([a, b], 1)

      c.shape.should eq([2, 5])
      c.data.should eq([1, 2, 5, 6, 7, 3, 4, 8, 9, 10])
    end

    it "raises an error if arrays have different shapes except for the concatenation axis" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([3, 3], [5, 6, 7, 8, 9, 10, 11, 12, 13])

      expect_raises(ArgumentError, /All arrays must have the same shape/) do
        Narray.concatenate([a, b])
      end
    end
  end

  describe ".vstack" do
    it "stacks 1D arrays vertically" do
      a = Narray.array([3], [1, 2, 3])
      b = Narray.array([3], [4, 5, 6])
      c = Narray.vstack([a, b])

      c.shape.should eq([2, 3])
      c.data.should eq([1, 2, 3, 4, 5, 6])
    end

    it "stacks 2D arrays vertically" do
      a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      b = Narray.array([1, 3], [7, 8, 9])
      c = Narray.vstack([a, b])

      c.shape.should eq([3, 3])
      c.data.should eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
    end
  end

  describe ".hstack" do
    it "stacks 1D arrays horizontally" do
      a = Narray.array([3], [1, 2, 3])
      b = Narray.array([3], [4, 5, 6])
      c = Narray.hstack([a, b])

      c.shape.should eq([6])
      c.data.should eq([1, 2, 3, 4, 5, 6])
    end

    it "stacks 2D arrays horizontally" do
      a = Narray.array([2, 2], [1, 2, 3, 4])
      b = Narray.array([2, 3], [5, 6, 7, 8, 9, 10])
      c = Narray.hstack([a, b])

      c.shape.should eq([2, 5])
      c.data.should eq([1, 2, 5, 6, 7, 3, 4, 8, 9, 10])
    end
  end
end
