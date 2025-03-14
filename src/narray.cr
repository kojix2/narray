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
    # arr.at([0, 0]) # => 1
    # arr.at([0, 1]) # => 2
    # arr.at([1, 2]) # => 6
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def at(indices : ::Array(Int32)) : T
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

    # Convenience method for accessing elements with variadic indices.
    #
    # ```
    # arr = Narray.array([2, 3, 4], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])
    # arr.at(0, 1, 2) # => 7
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def at(*indices : Int32) : T
      at(indices.to_a)
    end

    # Sets the element at the given indices.
    #
    # ```
    # arr = Narray.zeros([2, 3], Int32)
    # arr.at_set([0, 0], 1)
    # arr.at_set([0, 1], 2)
    # arr.at_set([1, 2], 3)
    # arr.data # => [1, 2, 0, 0, 0, 3]
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def at_set(indices : ::Array(Int32), value : T) : self
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

      # Calculate the flat index and set the value
      flat_idx = indices_to_flat_index(indices)
      data[flat_idx] = value
      self
    end

    # Convenience method for setting elements with variadic indices.
    #
    # ```
    # arr = Narray.zeros([2, 3], Int32)
    # arr.at_set(0, 0, 1)
    # arr.at_set(0, 1, 2)
    # arr.at_set(1, 2, 3)
    # arr.data # => [1, 2, 0, 0, 0, 3]
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def at_set(*args : Int32) : self
      # The last argument is the value, the rest are indices
      if args.size < 2 # Need at least one index and a value
        raise ArgumentError.new("Wrong number of arguments (#{args.size} for at least 2)")
      end

      # Extract indices and value
      value = args.last

      # Create an array of indices
      indices = ::Array(Int32).new(args.size - 1)
      (0...args.size - 1).each do |i|
        indices << args[i]
      end

      # Set the value
      at_set(indices, value)
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
      at(indices)
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
      at_set(indices, value)
    end

    # Type alias for slice indices
    alias SliceIndex = Int32 | Range(Int32, Int32) | Bool

    # Returns a slice of the array based on the given indices.
    #
    # Each index can be:
    # - An integer: selects a single element along that dimension
    # - A range: selects a range of elements along that dimension
    # - A boolean (true): selects all elements along that dimension
    #
    # ```
    # arr = Narray.array([3, 4], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    # arr.slice([0..1, 1..2]) # => 2D array with elements at positions (0,1), (0,2), (1,1), (1,2)
    # arr.slice([0, true])    # => 1D array with all elements in the first row
    # arr.slice([true, 2])    # => 1D array with elements at column index 2
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    def slice(indices : ::Array(SliceIndex)) : Array(T)
      # Validate indices count
      if indices.size != ndim
        raise IndexError.new("Wrong number of indices (#{indices.size} for #{ndim})")
      end

      # Calculate the new shape and prepare for data extraction
      new_shape = ::Array(Int32).new
      ranges = ::Array(Range(Int32, Int32)).new

      # Process each dimension
      indices.each_with_index do |idx, dim|
        dim_size = shape[dim]

        case idx
        when Int32
          # Handle negative indices (counting from the end)
          actual_idx = idx < 0 ? dim_size + idx : idx

          # Validate bounds
          if actual_idx < 0 || actual_idx >= dim_size
            raise IndexError.new("Index #{idx} is out of bounds for dimension #{dim} with size #{dim_size}")
          end

          # For a single index, the dimension collapses (size 1)
          new_shape << 1
          ranges << (actual_idx..actual_idx)
        when Range(Int32, Int32)
          # Handle negative indices in range (counting from the end)
          begin_idx = idx.begin < 0 ? dim_size + idx.begin : idx.begin
          end_idx = idx.end < 0 ? dim_size + idx.end : idx.end

          # Validate bounds
          if begin_idx < 0 || begin_idx >= dim_size || end_idx < 0 || end_idx >= dim_size
            raise IndexError.new("Range #{idx} is out of bounds for dimension #{dim} with size #{dim_size}")
          end

          # Create a new range with the adjusted indices
          adjusted_range = idx.exclusive? ? (begin_idx...end_idx) : (begin_idx..end_idx)

          # Calculate size of this dimension in the result
          size = end_idx - begin_idx + (idx.exclusive? ? 0 : 1)
          new_shape << size
          ranges << adjusted_range
        when Bool
          if idx # true means select all
            new_shape << dim_size
            ranges << (0...dim_size)
          else
            raise ArgumentError.new("Boolean index must be true (false not supported)")
          end
        end
      end

      # Extract data for the slice
      new_data = ::Array(T).new(new_shape.product)

      # Generate all combinations of indices within the specified ranges
      generate_indices_combinations(ranges) do |indices|
        flat_idx = indices_to_flat_index(indices)
        new_data << data[flat_idx]
      end

      # Create and return the new array
      Array(T).new(new_shape, new_data)
    end

    # Helper method to generate all combinations of indices within the given ranges
    private def generate_indices_combinations(ranges : ::Array(Range(Int32, Int32)), current_indices = [] of Int32, dimension = 0, &block : ::Array(Int32) -> Nil)
      if dimension == ranges.size
        # When we've processed all dimensions, yield the current indices
        yield current_indices.dup
      else
        # Process the current dimension
        range = ranges[dimension]
        range.each do |i|
          current_indices << i
          generate_indices_combinations(ranges, current_indices, dimension + 1, &block)
          current_indices.pop
        end
      end
    end

    # Sets a slice of the array to the given value.
    #
    # Each index can be:
    # - An integer: selects a single element along that dimension
    # - A range: selects a range of elements along that dimension
    # - A boolean (true): selects all elements along that dimension
    #
    # ```
    # arr = Narray.array([3, 4], (1..12).to_a)
    # sub_arr = Narray.array([2, 2], [100, 200, 300, 400])
    # arr.slice_set([0..1, 0..1], sub_arr) # Replace the top-left 2x2 submatrix
    # ```
    #
    # Raises `IndexError` if the number of indices does not match the number of dimensions.
    # Raises `IndexError` if any index is out of bounds.
    # Raises `ArgumentError` if the shape of the value does not match the shape of the slice.
    def slice_set(indices : ::Array(SliceIndex), value : Array(T)) : self
      # Validate indices count
      if indices.size != ndim
        raise IndexError.new("Wrong number of indices (#{indices.size} for #{ndim})")
      end

      # Calculate the new shape and prepare for data extraction
      slice_shape = ::Array(Int32).new
      ranges = ::Array(Range(Int32, Int32)).new

      # Process each dimension
      indices.each_with_index do |idx, dim|
        dim_size = shape[dim]

        case idx
        when Int32
          # Handle negative indices (counting from the end)
          actual_idx = idx < 0 ? dim_size + idx : idx

          # Validate bounds
          if actual_idx < 0 || actual_idx >= dim_size
            raise IndexError.new("Index #{idx} is out of bounds for dimension #{dim} with size #{dim_size}")
          end

          # For a single index, the dimension collapses (size 1)
          slice_shape << 1
          ranges << (actual_idx..actual_idx)
        when Range(Int32, Int32)
          # Handle negative indices in range (counting from the end)
          begin_idx = idx.begin < 0 ? dim_size + idx.begin : idx.begin
          end_idx = idx.end < 0 ? dim_size + idx.end : idx.end

          # Validate bounds
          if begin_idx < 0 || begin_idx >= dim_size || end_idx < 0 || end_idx >= dim_size
            raise IndexError.new("Range #{idx} is out of bounds for dimension #{dim} with size #{dim_size}")
          end

          # Create a new range with the adjusted indices
          adjusted_range = idx.exclusive? ? (begin_idx...end_idx) : (begin_idx..end_idx)

          # Calculate size of this dimension in the result
          size = end_idx - begin_idx + (idx.exclusive? ? 0 : 1)
          slice_shape << size
          ranges << adjusted_range
        when Bool
          if idx # true means select all
            slice_shape << dim_size
            ranges << (0...dim_size)
          else
            raise ArgumentError.new("Boolean index must be true (false not supported)")
          end
        end
      end

      # Validate that the value shape matches the slice shape
      if value.shape != slice_shape
        raise ArgumentError.new("Value shape #{value.shape} does not match slice shape #{slice_shape}")
      end

      # Set the values in the slice
      value_index = 0
      generate_indices_combinations(ranges) do |indices|
        flat_idx = indices_to_flat_index(indices)
        data[flat_idx] = value.data[value_index]
        value_index += 1
      end

      self
    end

    # Sets a slice of the array using bracket notation with slice indices.
    #
    # ```
    # arr = Narray.array([3, 4], (1..12).to_a)
    # sub_arr = Narray.array([2, 2], [100, 200, 300, 400])
    # arr[[0..1, 0..1]] = sub_arr # Replace the top-left 2x2 submatrix
    # ```
    #
    # See `#slice_set` for more details.
    def []=(indices : ::Array(SliceIndex), value : Array(T))
      slice_set(indices, value)
    end

    # Note: We intentionally do not provide a `[](indices : ::Array(SliceIndex))` method
    # to avoid conflicts with the existing `[](indices : ::Array(Int32))` method.
    # Use the `slice` method directly instead.

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
