# NArray: A multi-dimensional numerical array library for Crystal
#
# NArray is a library for scientific computing with Crystal, inspired by NumPy and Numo::NArray.
# It provides support for multi-dimensional arrays and various mathematical operations.
#
# ## Features
#
# * Support for multi-dimensional arrays (N-dimensional arrays)
# * Various array creation functions (zeros, ones, arange, linspace, etc.)
# * Array manipulation functions (reshape, transpose, concatenate, etc.)
# * Mathematical operations (basic arithmetic operations, element-wise functions)
# * Broadcasting support for operations between arrays of different shapes
# * Linear algebra functions (matrix multiplication, determinant, inverse, eigenvalues, SVD)
# * Statistical functions (mean, variance, standard deviation, etc.)

# Require all components
require "./narray/*"

module Narray
  VERSION = "0.1.0"

  # Main class for multi-dimensional arrays.
  #
  # This class represents a multi-dimensional array with elements of type T.
  # It provides methods for accessing and manipulating array elements, as well as
  # various mathematical operations.
  class Array(T)
    # The shape of the array (dimensions).
    #
    # Returns an array of integers representing the size of each dimension.
    # For example, a 2x3 array would have a shape of [2, 3].
    getter shape : ::Array(Int32)

    # The underlying data storage.
    #
    # Returns a flat array containing all elements of the multi-dimensional array.
    # Elements are stored in row-major order (C-style).
    getter data : ::Array(T)

    # Creates a new NArray with the given shape and data.
    #
    # The data array must have the same number of elements as the product of the shape dimensions.
    # Elements are stored in row-major order (C-style).
    #
    # ```
    # arr = Narray::Array(Int32).new([2, 2], [1, 2, 3, 4])
    # arr.shape # => [2, 2]
    # arr.data  # => [1, 2, 3, 4]
    # ```
    #
    # Raises `ArgumentError` if the data size does not match the shape.
    def initialize(@shape : ::Array(Int32), @data : ::Array(T))
      # Validate that the data size matches the shape
      expected_size = shape.product
      if data.size != expected_size
        raise ArgumentError.new("Data size (#{data.size}) does not match shape #{shape} (expected #{expected_size})")
      end
    end

    # Returns the number of dimensions of the array.
    #
    # ```
    # arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # arr.ndim # => 2
    # ```
    def ndim : Int32
      shape.size
    end

    # Returns the total number of elements in the array.
    #
    # ```
    # arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # arr.size # => 6
    # ```
    def size : Int32
      data.size
    end

    # Returns the element at the given indices.
    #
    # ```
    # arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # arr[[0, 0]] # => 1
    # arr[[0, 1]] # => 2
    # arr[[1, 2]] # => 6
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def [](indices : ::Array(Int32)) : T
      # Validate indices
      if indices.size != ndim
        raise IndexError.new("Wrong number of indices (#{indices.size} for #{ndim})")
      end

      # Check bounds
      indices.each_with_index do |idx, dim|
        if idx < 0 || idx >= shape[dim]
          raise IndexError.new("Index #{idx} is out of bounds for dimension #{dim} with size #{shape[dim]}")
        end
      end

      # Calculate the flat index
      flat_idx = indices_to_flat_index(indices)
      data[flat_idx]
    end

    # Sets the element at the given indices.
    #
    # ```
    # arr = Narray.zeros([2, 3], Int32)
    # arr[[0, 0]] = 1
    # arr[[0, 1]] = 2
    # arr[[1, 2]] = 3
    # arr.data # => [1, 2, 0, 0, 0, 3]
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def []=(indices : ::Array(Int32), value : T)
      # Validate indices
      if indices.size != ndim
        raise IndexError.new("Wrong number of indices (#{indices.size} for #{ndim})")
      end

      # Check bounds
      indices.each_with_index do |idx, dim|
        if idx < 0 || idx >= shape[dim]
          raise IndexError.new("Index #{idx} is out of bounds for dimension #{dim} with size #{shape[dim]}")
        end
      end

      # Calculate the flat index
      flat_idx = indices_to_flat_index(indices)
      data[flat_idx] = value
    end

    # Converts multi-dimensional indices to a flat index.
    #
    # This method calculates the flat index in the underlying data array
    # corresponding to the given multi-dimensional indices.
    private def indices_to_flat_index(indices : ::Array(Int32)) : Int32
      flat_idx = 0
      stride = 1

      (ndim - 1).downto(0) do |dim|
        flat_idx += indices[dim] * stride
        stride *= shape[dim]
      end

      flat_idx
    end

    # Returns a string representation of the array.
    #
    # ```
    # arr = Narray.array([2, 2], [1, 2, 3, 4])
    # arr.to_s # => "Narray.array([2, 2], [1, 2, 3, 4])"
    # ```
    def to_s(io : IO)
      io << "Narray.array("
      io << shape.inspect
      io << ", "
      io << data.inspect
      io << ")"
    end

    # Returns a detailed string representation of the array for debugging.
    #
    # For small arrays (size <= 20), all elements are shown.
    # For large arrays, only the first 10 and last 10 elements are shown.
    #
    # ```
    # arr = Narray.array([2, 2], [1, 2, 3, 4])
    # arr.inspect # => "Narray::Array(Int32)[shape=[2, 2], ndim=2, size=4, data=[1, 2, 3, 4]]"
    # ```
    def inspect(io : IO) : Nil
      io << "Narray::Array("
      io << T.name
      io << ")["

      # Print shape
      io << "shape="
      io << shape.inspect
      io << ", "

      # Print dimensions
      io << "ndim="
      io << ndim
      io << ", "

      # Print size
      io << "size="
      io << size
      io << ", "

      # Print data
      io << "data="

      # For large arrays, only show a subset of the data
      if size <= 20
        io << data.inspect
      else
        # Show first 10 and last 10 elements
        first_elements = data[0...10]
        last_elements = data[(size - 10)...size]

        io << "["
        first_elements.each_with_index do |elem, i|
          io << elem
          io << ", " if i < first_elements.size - 1
        end

        io << ", ... (#{size - 20} more elements) ... , "

        last_elements.each_with_index do |elem, i|
          io << elem
          io << ", " if i < last_elements.size - 1
        end
        io << "]"
      end

      io << "]"
    end
  end

  # Creates a new array with the given shape and data.
  #
  # ```
  # arr = Narray.array([2, 2], [1, 2, 3, 4])
  # arr.shape # => [2, 2]
  # arr.ndim  # => 2
  # arr.size  # => 4
  # arr.data  # => [1, 2, 3, 4]
  # ```
  #
  # Raises `ArgumentError` if the data size does not match the shape.
  #
  # See also: `Narray.zeros`, `Narray.ones`.
  def self.array(shape : ::Array(Int32), data : ::Array(T)) forall T
    Array(T).new(shape, data)
  end

  # Creates a new array filled with zeros.
  #
  # ```
  # arr = Narray.zeros([2, 3])
  # arr.shape # => [2, 3]
  # arr.ndim  # => 2
  # arr.size  # => 6
  # arr.data  # => [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
  # ```
  #
  # See also: `Narray.ones`, `Narray.array`.
  def self.zeros(shape : ::Array(Int32))
    data = ::Array(Float64).new(shape.product, 0.0)
    Array(Float64).new(shape, data)
  end

  # Creates a new array filled with zeros with the specified type.
  #
  # ```
  # arr = Narray.zeros([2, 2], Int32)
  # arr.data          # => [0, 0, 0, 0]
  # arr.data[0].class # => Int32
  # ```
  #
  # See also: `Narray.ones`, `Narray.array`.
  def self.zeros(shape : ::Array(Int32), type : T.class) forall T
    data = ::Array(T).new(shape.product, T.zero)
    Array(T).new(shape, data)
  end

  # Creates a new array filled with ones.
  #
  # ```
  # arr = Narray.ones([2, 3])
  # arr.shape # => [2, 3]
  # arr.ndim  # => 2
  # arr.size  # => 6
  # arr.data  # => [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
  # ```
  #
  # See also: `Narray.zeros`, `Narray.array`.
  def self.ones(shape : ::Array(Int32))
    data = ::Array(Float64).new(shape.product, 1.0)
    Array(Float64).new(shape, data)
  end

  # Creates a new array filled with ones with the specified type.
  #
  # ```
  # arr = Narray.ones([2, 2], Int32)
  # arr.data          # => [1, 1, 1, 1]
  # arr.data[0].class # => Int32
  # ```
  #
  # See also: `Narray.zeros`, `Narray.array`.
  def self.ones(shape : ::Array(Int32), type : T.class) forall T
    data = ::Array(T).new(shape.product, T.new(1))
    Array(T).new(shape, data)
  end

  # Creates a new array with evenly spaced values within a given interval.
  #
  # ```
  # arr = Narray.arange(0, 10, 2)
  # arr.shape # => [5]
  # arr.ndim  # => 1
  # arr.size  # => 5
  # arr.data  # => [0, 2, 4, 6, 8]
  # ```
  #
  # See also: `Narray.linspace`.
  def self.arange(start : Number, stop : Number, step = 1)
    # Calculate the number of elements
    n = ((stop - start) / step).ceil.to_i

    # Create the data array
    data = ::Array(Int32).new(n) do |i|
      (start + i * step).to_i
    end

    # Create the array with shape [n]
    Array(Int32).new([n], data)
  end

  # Creates a new array with evenly spaced values within a given interval with the specified type.
  #
  # ```
  # arr = Narray.arange(0, 5, 1_f64, Float64)
  # arr.data          # => [0.0, 1.0, 2.0, 3.0, 4.0]
  # arr.data[0].class # => Float64
  # ```
  #
  # See also: `Narray.linspace`.
  def self.arange(start : Number, stop : Number, step : Number, type : T.class) forall T
    # Calculate the number of elements
    n = ((stop - start) / step).ceil.to_i

    # Create the data array
    data = ::Array(T).new(n) do |i|
      T.new(start + i * step)
    end

    # Create the array with shape [n]
    Array(T).new([n], data)
  end

  # Creates a new array with evenly spaced values over a specified interval.
  #
  # ```
  # arr = Narray.linspace(0, 1, 5)
  # arr.shape # => [5]
  # arr.ndim  # => 1
  # arr.size  # => 5
  # arr.data  # => [0.0, 0.25, 0.5, 0.75, 1.0]
  # ```
  #
  # See also: `Narray.arange`.
  def self.linspace(start : Number, stop : Number, num = 50)
    # Create the data array
    data = ::Array(Float64).new(num) do |i|
      start + (stop - start) * (i / (num - 1).to_f)
    end

    # Create the array with shape [num]
    Array(Float64).new([num], data)
  end

  # Creates a new array with evenly spaced values over a specified interval with the specified type.
  #
  # ```
  # arr = Narray.linspace(0, 1, 3, Float32)
  # arr.data[0].class # => Float32
  # ```
  #
  # See also: `Narray.arange`.
  def self.linspace(start : Number, stop : Number, num : Int32, type : T.class) forall T
    # Create the data array
    data = ::Array(T).new(num) do |i|
      T.new(start + (stop - start) * (i / (num - 1).to_f))
    end

    # Create the array with shape [num]
    Array(T).new([num], data)
  end
end
