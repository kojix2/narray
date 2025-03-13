# NArray: A multi-dimensional numerical array library for Crystal

# Require all components
require "./narray/*"

module Narray
  VERSION = "0.1.0"

  # Main class for multi-dimensional arrays
  class Array(T)
    # The shape of the array (dimensions)
    getter shape : ::Array(Int32)

    # The underlying data storage
    getter data : ::Array(T)

    # Creates a new NArray with the given shape and data
    def initialize(@shape : ::Array(Int32), @data : ::Array(T))
      # Validate that the data size matches the shape
      expected_size = shape.product
      if data.size != expected_size
        raise ArgumentError.new("Data size (#{data.size}) does not match shape #{shape} (expected #{expected_size})")
      end
    end

    # Returns the number of dimensions of the array
    def ndim : Int32
      shape.size
    end

    # Returns the total number of elements in the array
    def size : Int32
      data.size
    end

    # Returns the element at the given indices
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

    # Sets the element at the given indices
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

    # Converts multi-dimensional indices to a flat index
    private def indices_to_flat_index(indices : ::Array(Int32)) : Int32
      flat_idx = 0
      stride = 1

      (ndim - 1).downto(0) do |dim|
        flat_idx += indices[dim] * stride
        stride *= shape[dim]
      end

      flat_idx
    end

    # Returns a string representation of the array
    def to_s(io : IO)
      io << "Narray.array("
      io << shape.inspect
      io << ", "
      io << data.inspect
      io << ")"
    end

    # Returns a detailed string representation of the array for debugging
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

  # Creates a new array with the given shape and data
  def self.array(shape : ::Array(Int32), data : ::Array(T)) forall T
    Array(T).new(shape, data)
  end

  # Creates a new array filled with zeros
  def self.zeros(shape : ::Array(Int32))
    data = ::Array(Float64).new(shape.product, 0.0)
    Array(Float64).new(shape, data)
  end

  # Creates a new array filled with zeros with the specified type
  def self.zeros(shape : ::Array(Int32), type : T.class) forall T
    data = ::Array(T).new(shape.product, T.zero)
    Array(T).new(shape, data)
  end

  # Creates a new array filled with ones
  def self.ones(shape : ::Array(Int32))
    data = ::Array(Float64).new(shape.product, 1.0)
    Array(Float64).new(shape, data)
  end

  # Creates a new array filled with ones with the specified type
  def self.ones(shape : ::Array(Int32), type : T.class) forall T
    data = ::Array(T).new(shape.product, T.new(1))
    Array(T).new(shape, data)
  end

  # Creates a new array with evenly spaced values within a given interval
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

  # Creates a new array with evenly spaced values within a given interval with the specified type
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

  # Creates a new array with evenly spaced values over a specified interval
  def self.linspace(start : Number, stop : Number, num = 50)
    # Create the data array
    data = ::Array(Float64).new(num) do |i|
      start + (stop - start) * (i / (num - 1).to_f)
    end

    # Create the array with shape [num]
    Array(Float64).new([num], data)
  end

  # Creates a new array with evenly spaced values over a specified interval with the specified type
  def self.linspace(start : Number, stop : Number, num : Int32, type : T.class) forall T
    # Create the data array
    data = ::Array(T).new(num) do |i|
      T.new(start + (stop - start) * (i / (num - 1).to_f))
    end

    # Create the array with shape [num]
    Array(T).new([num], data)
  end
end
