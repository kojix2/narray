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

  describe "Array#reshape!" do
    it "reshapes a 1D array to 2D in-place" do
      arr = Narray.arange(0, 6)
      original_data = arr.data.dup
      result = arr.reshape!([2, 3])

      # Check that the result is the same object
      result.should be(arr)

      # Check that the shape was updated
      arr.shape.should eq([2, 3])
      arr.ndim.should eq(2)
      arr.size.should eq(6)

      # Check that the data was not changed
      arr.data.should eq(original_data)
    end

    it "reshapes a 2D array to 1D in-place" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      original_data = arr.data.dup
      result = arr.reshape!([6])

      # Check that the result is the same object
      result.should be(arr)

      # Check that the shape was updated
      arr.shape.should eq([6])
      arr.ndim.should eq(1)
      arr.size.should eq(6)

      # Check that the data was not changed
      arr.data.should eq(original_data)
    end

    it "raises an error if the new shape has a different number of elements" do
      arr = Narray.arange(0, 6)

      expect_raises(ArgumentError, /Cannot reshape/) do
        arr.reshape!([2, 4])
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

  describe "Array#transpose!" do
    it "does nothing for a 1D array" do
      arr = Narray.arange(0, 3)
      original_data = arr.data.dup
      original_shape = arr.shape.dup
      result = arr.transpose!

      # Check that the result is the same object
      result.should be(arr)

      # Check that nothing changed
      arr.shape.should eq(original_shape)
      arr.data.should eq(original_data)
    end

    it "transposes a 2D array in-place" do
      arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
      result = arr.transpose!

      # Check that the result is the same object
      result.should be(arr)

      # Check that the shape was updated
      arr.shape.should eq([3, 2])

      # Check that the data was updated correctly
      arr.data.should eq([1, 4, 2, 5, 3, 6])
    end

    it "transposes a 3D array in-place" do
      arr = Narray.array([2, 2, 2], [1, 2, 3, 4, 5, 6, 7, 8])
      result = arr.transpose!

      # Check that the result is the same object
      result.should be(arr)

      # Check that the shape was updated
      arr.shape.should eq([2, 2, 2])

      # Check that the data was updated correctly
      arr.data.should eq([1, 5, 3, 7, 2, 6, 4, 8])
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

  describe "Mask operations" do
    describe "Array#mask" do
      it "returns elements where mask is true" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([5], [true, false, true, false, true])
        result = arr.mask(mask)

        result.shape.should eq([3])
        result.data.should eq([1, 3, 5])
      end

      it "raises an error if mask shape does not match array shape" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([3], [true, false, true])

        expect_raises(ArgumentError, /Mask shape/) do
          arr.mask(mask)
        end
      end

      it "works with a block condition" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        result = arr.mask { |x| x > 2 }

        result.shape.should eq([3])
        result.data.should eq([3, 4, 5])
      end
    end

    describe "Array#mask_set" do
      it "sets elements where mask is true to a value" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([5], [true, false, true, false, true])
        arr.mask_set(mask, 0)

        arr.data.should eq([0, 2, 0, 4, 0])
      end

      it "sets elements where mask is true to values from another array" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([5], [true, false, true, false, true])
        values = Narray.array([3], [10, 20, 30])
        arr.mask_set(mask, values)

        arr.data.should eq([10, 2, 20, 4, 30])
      end

      it "raises an error if mask shape does not match array shape" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([3], [true, false, true])

        expect_raises(ArgumentError, /Mask shape/) do
          arr.mask_set(mask, 0)
        end
      end

      it "raises an error if values array size does not match true count in mask" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = Narray.array([5], [true, false, true, false, true])
        values = Narray.array([2], [10, 20])

        expect_raises(ArgumentError, /Values array size/) do
          arr.mask_set(mask, values)
        end
      end

      it "works with a block condition" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        arr.mask_set(0) { |x| x > 2 }

        arr.data.should eq([1, 2, 0, 0, 0])
      end
    end
  end

  describe "Comparison operations" do
    describe "Array#eq" do
      it "returns a boolean mask for equality with a value" do
        arr = Narray.array([5], [1, 2, 3, 2, 1])
        mask = arr.eq(2)

        mask.shape.should eq([5])
        mask.data.should eq([false, true, false, true, false])
      end
    end

    describe "Array#ne" do
      it "returns a boolean mask for inequality with a value" do
        arr = Narray.array([5], [1, 2, 3, 2, 1])
        mask = arr.ne(2)

        mask.shape.should eq([5])
        mask.data.should eq([true, false, true, false, true])
      end
    end

    describe "Array#gt" do
      it "returns a boolean mask for greater than a value" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = arr.gt(3)

        mask.shape.should eq([5])
        mask.data.should eq([false, false, false, true, true])
      end
    end

    describe "Array#ge" do
      it "returns a boolean mask for greater than or equal to a value" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = arr.ge(3)

        mask.shape.should eq([5])
        mask.data.should eq([false, false, true, true, true])
      end
    end

    describe "Array#lt" do
      it "returns a boolean mask for less than a value" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = arr.lt(3)

        mask.shape.should eq([5])
        mask.data.should eq([true, true, false, false, false])
      end
    end

    describe "Array#le" do
      it "returns a boolean mask for less than or equal to a value" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])
        mask = arr.le(3)

        mask.shape.should eq([5])
        mask.data.should eq([true, true, true, false, false])
      end
    end

    describe "Array comparison operations between arrays" do
      it "compares arrays with eq" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [1, 3, 3])
        mask = a.eq(b)

        mask.shape.should eq([3])
        mask.data.should eq([true, false, true])
      end

      it "compares arrays with ne" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [1, 3, 3])
        mask = a.ne(b)

        mask.shape.should eq([3])
        mask.data.should eq([false, true, false])
      end

      it "compares arrays with gt" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a.gt(b)

        mask.shape.should eq([3])
        mask.data.should eq([true, false, false])
      end

      it "compares arrays with broadcasting" do
        a = Narray.array([2, 1], [1, 2])
        b = Narray.array([1, 3], [0, 1, 2])
        mask = a.gt(b)

        mask.shape.should eq([2, 3])
        mask.data.should eq([true, false, false, true, true, false])
      end

      it "compares arrays with ge" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a.ge(b)

        mask.shape.should eq([3])
        mask.data.should eq([true, true, false])
      end

      it "compares arrays with lt" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a.lt(b)

        mask.shape.should eq([3])
        mask.data.should eq([false, false, true])
      end

      it "compares arrays with le" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a.le(b)

        mask.shape.should eq([3])
        mask.data.should eq([false, true, true])
      end
    end

    describe "Array comparison operations with operators" do
      it "compares arrays with == operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [1, 3, 3])
        mask = a == b

        mask.shape.should eq([3])
        mask.data.should eq([true, false, true])
      end

      it "compares arrays with != operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [1, 3, 3])
        mask = a != b

        mask.shape.should eq([3])
        mask.data.should eq([false, true, false])
      end

      it "compares arrays with > operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a > b

        mask.shape.should eq([3])
        mask.data.should eq([true, false, false])
      end

      it "compares arrays with >= operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a >= b

        mask.shape.should eq([3])
        mask.data.should eq([true, true, false])
      end

      it "compares arrays with < operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a < b

        mask.shape.should eq([3])
        mask.data.should eq([false, false, true])
      end

      it "compares arrays with <= operator" do
        a = Narray.array([3], [1, 2, 3])
        b = Narray.array([3], [0, 2, 4])
        mask = a <= b

        mask.shape.should eq([3])
        mask.data.should eq([false, true, true])
      end

      it "compares arrays with scalars using operators" do
        arr = Narray.array([5], [1, 2, 3, 4, 5])

        (arr == 3).data.should eq([false, false, true, false, false])
        (arr != 3).data.should eq([true, true, false, true, true])
        (arr > 3).data.should eq([false, false, false, true, true])
        (arr >= 3).data.should eq([false, false, true, true, true])
        (arr < 3).data.should eq([true, true, false, false, false])
        (arr <= 3).data.should eq([true, true, true, false, false])
      end

      it "compares arrays with broadcasting using operators" do
        a = Narray.array([2, 1], [1, 2])
        b = Narray.array([1, 3], [0, 1, 2])

        mask = a > b
        mask.shape.should eq([2, 3])
        mask.data.should eq([true, false, false, true, true, false])

        mask = a >= b
        mask.shape.should eq([2, 3])
        mask.data.should eq([true, true, false, true, true, true])

        mask = a < b
        mask.shape.should eq([2, 3])
        mask.data.should eq([false, false, true, false, false, false])

        mask = a <= b
        mask.shape.should eq([2, 3])
        mask.data.should eq([false, true, true, false, false, true])
      end
    end
  end
end
