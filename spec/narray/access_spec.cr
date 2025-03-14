require "../spec_helper"

describe Narray do
  describe "Array#at" do
    describe "with array indices" do
      it "returns the element at the given indices" do
        arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
        arr.at([0, 0]).should eq(1)
        arr.at([0, 1]).should eq(2)
        arr.at([0, 2]).should eq(3)
        arr.at([1, 0]).should eq(4)
        arr.at([1, 1]).should eq(5)
        arr.at([1, 2]).should eq(6)
      end

      it "works with 3D arrays" do
        arr = Narray.array([2, 2, 2], [1, 2, 3, 4, 5, 6, 7, 8])
        arr.at([0, 0, 0]).should eq(1)
        arr.at([0, 0, 1]).should eq(2)
        arr.at([0, 1, 0]).should eq(3)
        arr.at([0, 1, 1]).should eq(4)
        arr.at([1, 0, 0]).should eq(5)
        arr.at([1, 0, 1]).should eq(6)
        arr.at([1, 1, 0]).should eq(7)
        arr.at([1, 1, 1]).should eq(8)
      end

      it "raises an error for invalid indices" do
        arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.at([0])
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at([2, 0])
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at([0, 3])
        end
      end
    end

    describe "with variadic indices" do
      it "returns the element at the given indices" do
        arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
        arr.at(0, 0).should eq(1)
        arr.at(0, 1).should eq(2)
        arr.at(0, 2).should eq(3)
        arr.at(1, 0).should eq(4)
        arr.at(1, 1).should eq(5)
        arr.at(1, 2).should eq(6)
      end

      it "works with 3D arrays" do
        arr = Narray.array([2, 2, 2], [1, 2, 3, 4, 5, 6, 7, 8])
        arr.at(0, 0, 0).should eq(1)
        arr.at(0, 0, 1).should eq(2)
        arr.at(0, 1, 0).should eq(3)
        arr.at(0, 1, 1).should eq(4)
        arr.at(1, 0, 0).should eq(5)
        arr.at(1, 0, 1).should eq(6)
        arr.at(1, 1, 0).should eq(7)
        arr.at(1, 1, 1).should eq(8)
      end

      it "raises an error for invalid indices" do
        arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.at(0)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at(2, 0)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at(0, 3)
        end
      end
    end
  end

  describe "Array#set_at" do
    describe "with array indices" do
      it "sets the element at the given indices" do
        arr = Narray.zeros([2, 3], Int32)
        arr.set_at([0, 0], 1)
        arr.set_at([0, 1], 2)
        arr.set_at([1, 2], 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "returns self for method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        result = arr.set_at([0, 0], 1)

        result.should be(arr)
      end

      it "supports method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        arr.set_at([0, 0], 1).set_at([0, 1], 2).set_at([1, 2], 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "works with 3D arrays" do
        arr = Narray.zeros([2, 2, 2], Int32)
        arr.set_at([0, 0, 0], 1)
        arr.set_at([1, 1, 1], 8)

        arr.at([0, 0, 0]).should eq(1)
        arr.at([1, 1, 1]).should eq(8)
      end

      it "raises an error for invalid indices" do
        arr = Narray.zeros([2, 3], Int32)

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.set_at([0], 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.set_at([2, 0], 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.set_at([0, 3], 1)
        end
      end
    end

    describe "with variadic indices" do
      it "sets the element at the given indices" do
        arr = Narray.zeros([2, 3], Int32)
        arr.set_at(0, 0, 1)
        arr.set_at(0, 1, 2)
        arr.set_at(1, 2, 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "returns self for method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        result = arr.set_at(0, 0, 1)

        result.should be(arr)
      end

      it "supports method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        arr.set_at(0, 0, 1).set_at(0, 1, 2).set_at(1, 2, 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "works with 3D arrays" do
        arr = Narray.zeros([2, 2, 2], Int32)
        arr.set_at(0, 0, 0, 1)
        arr.set_at(1, 1, 1, 8)

        arr.at(0, 0, 0).should eq(1)
        arr.at(1, 1, 1).should eq(8)
      end

      it "raises an error for invalid arguments" do
        arr = Narray.zeros([2, 3], Int32)

        expect_raises(ArgumentError, /Wrong number of arguments/) do
          arr.set_at(0)
        end

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.set_at(0, 1)  # Missing value
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.set_at(2, 0, 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.set_at(0, 3, 1)
        end
      end
    end
  end

  describe "Array#[]" do
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

  describe "Array#[]=" do
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

  describe "Array#slice" do
    it "slices with integer indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Select a single element (returns a 1x1 array)
      result = arr.slice([1, 2])
      result.shape.should eq([1, 1])
      result.data.should eq([7])

      # Select elements at fixed positions in each dimension
      result = arr.slice([0, 1])
      result.shape.should eq([1, 1])
      result.data.should eq([2])
    end

    it "slices with range indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Select a submatrix
      result = arr.slice([0..1, 1..2])
      result.shape.should eq([2, 2])
      result.data.should eq([2, 3, 6, 7])

      # Select a row
      result = arr.slice([1, 0..3])
      result.shape.should eq([1, 4])
      result.data.should eq([5, 6, 7, 8])

      # Select a column
      result = arr.slice([0..2, 2])
      result.shape.should eq([3, 1])
      result.data.should eq([3, 7, 11])
    end

    it "slices with boolean (true) for entire dimension" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Select all rows for a specific column
      result = arr.slice([true, 2])
      result.shape.should eq([3, 1])
      result.data.should eq([3, 7, 11])

      # Select all columns for a specific row
      result = arr.slice([1, true])
      result.shape.should eq([1, 4])
      result.data.should eq([5, 6, 7, 8])
    end

    it "slices with mixed index types" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Integer and range
      result = arr.slice([1, 0..2])
      result.shape.should eq([1, 3])
      result.data.should eq([5, 6, 7])

      # Integer and boolean
      result = arr.slice([0, true])
      result.shape.should eq([1, 4])
      result.data.should eq([1, 2, 3, 4])

      # Range and boolean
      result = arr.slice([0..1, true])
      result.shape.should eq([2, 4])
      result.data.should eq([1, 2, 3, 4, 5, 6, 7, 8])
    end

    it "works with 3D arrays" do
      # Create a 2x2x2 array with values 1-8
      arr = Narray.array([2, 2, 2], (1..8).to_a)

      # Select a 2D slice
      result = arr.slice([0, true, true])
      result.shape.should eq([1, 2, 2])
      result.data.should eq([1, 2, 3, 4])

      # Select a 1D slice
      result = arr.slice([0, 0, 0..1])
      result.shape.should eq([1, 1, 2])
      result.data.should eq([1, 2])
    end

    it "supports negative indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Negative integer indices
      result = arr.slice([-1, 0])
      result.shape.should eq([1, 1])
      result.data.should eq([9])

      result = arr.slice([-2, -1])
      result.shape.should eq([1, 1])
      result.data.should eq([8])

      # Negative range indices
      result = arr.slice([-2..-1, 0..1])
      result.shape.should eq([2, 2])
      result.data.should eq([5, 6, 9, 10])

      result = arr.slice([0..1, -2..-1])
      result.shape.should eq([2, 2])
      result.data.should eq([3, 4, 7, 8])

      # Mixed positive and negative indices
      result = arr.slice([-3, 0..-2])
      result.shape.should eq([1, 3])
      result.data.should eq([1, 2, 3])
    end

    it "raises an error for invalid indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      expect_raises(IndexError, /Wrong number of indices/) do
        arr.slice([0])
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice([3, 0])
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice([0, 4])
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice([0..3, 0])
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice([-4, 0]) # Out of bounds negative index
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice([0, -5]) # Out of bounds negative index
      end

      expect_raises(ArgumentError, /Boolean index must be true/) do
        arr.slice([false, 0])
      end
    end
  end

  describe "Array#[] with slice indices" do
    it "supports slicing with slice method" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Integer indices
      result = arr.slice([1, 2])
      result.shape.should eq([1, 1])
      result.data.should eq([7])

      # Range indices
      result = arr.slice([0..1, 1..2])
      result.shape.should eq([2, 2])
      result.data.should eq([2, 3, 6, 7])

      # Boolean indices
      result = arr.slice([true, 2])
      result.shape.should eq([3, 1])
      result.data.should eq([3, 7, 11])

      # Mixed indices
      result = arr.slice([1, 0..2])
      result.shape.should eq([1, 3])
      result.data.should eq([5, 6, 7])
    end
  end
end
