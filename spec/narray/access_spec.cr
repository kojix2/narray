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
          arr.set_at(0, 1) # Missing value
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
end
