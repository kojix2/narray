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

  describe "Array#at_set" do
    describe "with array indices" do
      it "sets the element at the given indices" do
        arr = Narray.zeros([2, 3], Int32)
        arr.at_set([0, 0], 1)
        arr.at_set([0, 1], 2)
        arr.at_set([1, 2], 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "returns self for method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        result = arr.at_set([0, 0], 1)

        result.should be(arr)
      end

      it "supports method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        arr.at_set([0, 0], 1).at_set([0, 1], 2).at_set([1, 2], 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "works with 3D arrays" do
        arr = Narray.zeros([2, 2, 2], Int32)
        arr.at_set([0, 0, 0], 1)
        arr.at_set([1, 1, 1], 8)

        arr.at([0, 0, 0]).should eq(1)
        arr.at([1, 1, 1]).should eq(8)
      end

      it "raises an error for invalid indices" do
        arr = Narray.zeros([2, 3], Int32)

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.at_set([0], 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at_set([2, 0], 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at_set([0, 3], 1)
        end
      end
    end

    describe "with variadic indices" do
      it "sets the element at the given indices" do
        arr = Narray.zeros([2, 3], Int32)
        arr.at_set(0, 0, 1)
        arr.at_set(0, 1, 2)
        arr.at_set(1, 2, 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "returns self for method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        result = arr.at_set(0, 0, 1)

        result.should be(arr)
      end

      it "supports method chaining" do
        arr = Narray.zeros([2, 3], Int32)
        arr.at_set(0, 0, 1).at_set(0, 1, 2).at_set(1, 2, 3)

        arr.data.should eq([1, 2, 0, 0, 0, 3])
      end

      it "works with 3D arrays" do
        arr = Narray.zeros([2, 2, 2], Int32)
        arr.at_set(0, 0, 0, 1)
        arr.at_set(1, 1, 1, 8)

        arr.at(0, 0, 0).should eq(1)
        arr.at(1, 1, 1).should eq(8)
      end

      it "raises an error for invalid arguments" do
        arr = Narray.zeros([2, 3], Int32)

        expect_raises(ArgumentError, /Wrong number of arguments/) do
          arr.at_set(0)
        end

        expect_raises(IndexError, /Wrong number of indices/) do
          arr.at_set(0, 1)  # Missing value
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at_set(2, 0, 1)
        end

        expect_raises(IndexError, /out of bounds/) do
          arr.at_set(0, 3, 1)
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

  describe "Array#slice_set" do
    it "sets a slice of the array to the given value" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr = Narray.array([2, 2], [100, 200, 300, 400])

      # Replace a submatrix
      arr.slice_set([0..1, 0..1], sub_arr)
      arr.slice([0..1, 0..1]).data.should eq([100, 200, 300, 400])

      # The rest of the array should remain unchanged
      arr.at([0, 2]).should eq(3)
      arr.at([0, 3]).should eq(4)
      arr.at([1, 2]).should eq(7)
      arr.at([1, 3]).should eq(8)
      arr.at([2, 0]).should eq(9)
      arr.at([2, 1]).should eq(10)
      arr.at([2, 2]).should eq(11)
      arr.at([2, 3]).should eq(12)
    end

    it "supports method chaining" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr1 = Narray.array([1, 1], [100])
      sub_arr2 = Narray.array([1, 1], [200])

      result = arr.slice_set([0, 0], sub_arr1)
      result.should be(arr)

      arr.slice_set([0, 0], sub_arr1).slice_set([1, 1], sub_arr2)
      arr.at([0, 0]).should eq(100)
      arr.at([1, 1]).should eq(200)
    end

    it "supports negative indices" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr = Narray.array([2, 2], [100, 200, 300, 400])

      # Replace using negative range indices
      arr.slice_set([-2..-1, 0..1], sub_arr)
      arr.slice([-2..-1, 0..1]).data.should eq([100, 200, 300, 400])

      # The rest of the array should remain unchanged
      arr.at([0, 0]).should eq(1)
      arr.at([0, 1]).should eq(2)
      arr.at([0, 2]).should eq(3)
      arr.at([0, 3]).should eq(4)
      arr.at([1, 2]).should eq(7)
      arr.at([1, 3]).should eq(8)
      arr.at([2, 2]).should eq(11)
      arr.at([2, 3]).should eq(12)

      # Reset the array
      arr = Narray.array([3, 4], (1..12).to_a)

      # Replace using single negative indices
      single_row = Narray.array([1, 4], [100, 200, 300, 400])
      arr.slice_set([-1, true], single_row)
      arr.slice([-1, true]).data.should eq([100, 200, 300, 400])

      # The rest of the array should remain unchanged
      arr.at([0, 0]).should eq(1)
      arr.at([0, 1]).should eq(2)
      arr.at([0, 2]).should eq(3)
      arr.at([0, 3]).should eq(4)
      arr.at([1, 0]).should eq(5)
      arr.at([1, 1]).should eq(6)
      arr.at([1, 2]).should eq(7)
      arr.at([1, 3]).should eq(8)

      # Reset the array
      arr = Narray.array([3, 4], (1..12).to_a)

      # Replace using mixed negative indices
      single_element = Narray.array([1, 1], [999])
      arr.slice_set([-2, -3], single_element)
      arr.at([1, 1]).should eq(999) # -2 row, -3 column should be [1, 1]
    end

    it "supports boolean (true) indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Replace an entire row
      row_data = Narray.array([1, 4], [100, 200, 300, 400])
      arr.slice_set([0, true], row_data)
      arr.slice([0, true]).data.should eq([100, 200, 300, 400])

      # Replace an entire column
      col_data = Narray.array([3, 1], [500, 600, 700])
      arr.slice_set([true, 1], col_data)
      arr.slice([true, 1]).data.should eq([500, 600, 700])

      # The rest of the array should be as expected
      arr.at([0, 0]).should eq(100)
      arr.at([0, 2]).should eq(300)
      arr.at([0, 3]).should eq(400)
      arr.at([1, 0]).should eq(5)
      arr.at([1, 2]).should eq(7)
      arr.at([1, 3]).should eq(8)
      arr.at([2, 0]).should eq(9)
      arr.at([2, 2]).should eq(11)
      arr.at([2, 3]).should eq(12)
    end

    it "supports integer indices" do
      arr = Narray.array([3, 4], (1..12).to_a)

      # Replace a single element
      single_element = Narray.array([1, 1], [100])
      arr.slice_set([0, 0], single_element)
      arr.at([0, 0]).should eq(100)

      # Replace a row with a single integer index
      row_data = Narray.array([1, 4], [200, 300, 400, 500])
      arr.slice_set([1, true], row_data)
      arr.slice([1, true]).data.should eq([200, 300, 400, 500])

      # Replace a column with a single integer index
      col_data = Narray.array([3, 1], [600, 700, 800])
      arr.slice_set([true, 2], col_data)
      arr.slice([true, 2]).data.should eq([600, 700, 800])
    end

    it "raises an error if the value shape does not match the slice shape" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr = Narray.array([3, 2], (1..6).to_a)

      expect_raises(ArgumentError, /Value shape \[3, 2\] does not match slice shape \[2, 2\]/) do
        arr.slice_set([0..1, 0..1], sub_arr)
      end
    end

    it "raises an error for invalid indices" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr = Narray.array([1, 1], [100])

      expect_raises(IndexError, /Wrong number of indices/) do
        arr.slice_set([0], sub_arr)
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice_set([3, 0], sub_arr)
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice_set([0, 4], sub_arr)
      end

      expect_raises(IndexError, /out of bounds/) do
        arr.slice_set([-4, 0], sub_arr)
      end
    end
  end

  describe "Array#[]= with slice indices" do
    it "sets a slice of the array using bracket notation" do
      arr = Narray.array([3, 4], (1..12).to_a)
      sub_arr = Narray.array([2, 2], [100, 200, 300, 400])

      arr[[0..1, 0..1]] = sub_arr
      arr.slice([0..1, 0..1]).data.should eq([100, 200, 300, 400])
    end
  end
end
