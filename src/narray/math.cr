# Mathematical operations for NArray
module Narray
  class Array(T)
    # Element-wise addition
    def +(other : Array(T)) : Array(T)
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot add arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Add each element
      size.times do |i|
        new_data[i] = data[i] + other.data[i]
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise addition with a scalar
    def +(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Add scalar to each element
      size.times do |i|
        new_data[i] = data[i] + T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise addition in-place
    def add!(other : Array(T)) : self
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot add arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Add each element in-place
      size.times do |i|
        @data[i] += other.data[i]
      end

      self
    end

    # Element-wise addition with a scalar in-place
    def add!(scalar : Number) : self
      # Add scalar to each element in-place
      size.times do |i|
        @data[i] += T.new(scalar)
      end

      self
    end

    # Element-wise subtraction
    def -(other : Array(T)) : Array(T)
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot subtract arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Subtract each element
      size.times do |i|
        new_data[i] = data[i] - other.data[i]
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise subtraction with a scalar
    def -(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Subtract scalar from each element
      size.times do |i|
        new_data[i] = data[i] - T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise subtraction in-place
    def subtract!(other : Array(T)) : self
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot subtract arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Subtract each element in-place
      size.times do |i|
        @data[i] -= other.data[i]
      end

      self
    end

    # Element-wise subtraction with a scalar in-place
    def subtract!(scalar : Number) : self
      # Subtract scalar from each element in-place
      size.times do |i|
        @data[i] -= T.new(scalar)
      end

      self
    end

    # Element-wise multiplication
    def *(other : Array(T)) : Array(T)
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot multiply arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Multiply each element
      size.times do |i|
        new_data[i] = data[i] * other.data[i]
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise multiplication with a scalar
    def *(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Multiply each element by scalar
      size.times do |i|
        new_data[i] = data[i] * T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise multiplication in-place
    def multiply!(other : Array(T)) : self
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot multiply arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Multiply each element in-place
      size.times do |i|
        @data[i] *= other.data[i]
      end

      self
    end

    # Element-wise multiplication with a scalar in-place
    def multiply!(scalar : Number) : self
      # Multiply each element by scalar in-place
      size.times do |i|
        @data[i] *= T.new(scalar)
      end

      self
    end

    # Element-wise division
    def /(other : Array(T)) : Array(T)
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot divide arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Divide each element
      size.times do |i|
        new_data[i] = T.new((data[i] / other.data[i]).to_f)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise division with a scalar
    def /(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Divide each element by scalar
      size.times do |i|
        new_data[i] = T.new((data[i] / T.new(scalar)).to_f)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Element-wise division in-place
    def divide!(other : Array(T)) : self
      # Check that shapes match
      if shape != other.shape
        raise ArgumentError.new("Cannot divide arrays with different shapes: #{shape} and #{other.shape}")
      end

      # Divide each element in-place
      size.times do |i|
        @data[i] = T.new((@data[i] / other.data[i]).to_f)
      end

      self
    end

    # Element-wise division with a scalar in-place
    def divide!(scalar : Number) : self
      # Divide each element by scalar in-place
      size.times do |i|
        @data[i] = T.new((@data[i] / T.new(scalar)).to_f)
      end

      self
    end

    # Element-wise negation
    def -
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Negate each element
      size.times do |i|
        new_data[i] = T.new(-data[i])
      end

      Array(T).new(shape.dup, new_data)
    end

    # Sum of all elements
    def sum : T
      data.sum
    end

    # Mean of all elements
    def mean : Float64
      sum.to_f / size
    end

    # Minimum value
    def min : T
      data.min
    end

    # Maximum value
    def max : T
      data.max
    end

    # Standard deviation
    def std : Float64
      m = mean
      variance = data.sum { |x| (x.to_f - m) ** 2 } / size
      Math.sqrt(variance)
    end
  end

  # Matrix multiplication (dot product)
  def self.dot(a : Array(T), b : Array(T)) : Array(T) forall T
    # Check dimensions
    if a.ndim != 2 || b.ndim != 2
      raise ArgumentError.new("Both arrays must be 2-dimensional for dot product")
    end

    # Check that inner dimensions match
    a_rows, a_cols = a.shape
    b_rows, b_cols = b.shape

    if a_cols != b_rows
      raise ArgumentError.new("Inner dimensions must match: #{a.shape} and #{b.shape}")
    end

    # Create a new array with shape [a_rows, b_cols]
    new_shape = [a_rows, b_cols]
    new_data = ::Array(T).new(new_shape.product) { T.zero }

    # Compute the dot product
    a_rows.times do |i|
      b_cols.times do |j|
        sum = T.zero
        a_cols.times do |k|
          sum += a[[i, k]] * b[[k, j]]
        end
        new_data[i * b_cols + j] = sum
      end
    end

    Array(T).new(new_shape, new_data)
  end

  # Matrix multiplication (matmul)
  def self.matmul(a : Array(T), b : Array(T)) : Array(T) forall T
    dot(a, b)
  end
end
