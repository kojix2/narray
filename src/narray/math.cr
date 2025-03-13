# Mathematical operations for NArray
module Narray
  class Array(T)
    # Element-wise addition
    def +(other : Array(T)) : Array(T)
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        new_data = ::Array(T).new(size) { T.zero }

        # Add each element
        size.times do |i|
          new_data[i] = data[i] + other.data[i]
        end

        Array(T).new(shape.dup, new_data)
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # Shapes are compatible for broadcasting
        # Broadcast both arrays to the result shape
        broadcasted_self = Narray.broadcast(self, result_shape)
        broadcasted_other = Narray.broadcast(other, result_shape)

        # Add the broadcasted arrays
        new_data = ::Array(T).new(result_shape.product) { T.zero }

        result_shape.product.times do |i|
          new_data[i] = broadcasted_self.data[i] + broadcasted_other.data[i]
        end

        Array(T).new(result_shape, new_data)
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot add arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        # Add each element in-place
        size.times do |i|
          @data[i] += other.data[i]
        end

        self
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # If the result shape is different from our shape, we need to create a new array
        # This is because we can't modify our shape in-place if broadcasting changes it
        if result_shape != shape
          # Create a new array with the broadcasted result
          broadcasted_self = Narray.broadcast(self, result_shape)
          broadcasted_other = Narray.broadcast(other, result_shape)

          # Add the broadcasted arrays
          result_shape.product.times do |i|
            broadcasted_self.data[i] += broadcasted_other.data[i]
          end

          # Replace our data and shape with the new ones
          @data = broadcasted_self.data
          @shape = result_shape

          self
        else
          # Our shape is the result shape, so we can broadcast the other array to our shape
          broadcasted_other = Narray.broadcast(other, shape)

          # Add the broadcasted array to our data in-place
          size.times do |i|
            @data[i] += broadcasted_other.data[i]
          end

          self
        end
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot add arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        new_data = ::Array(T).new(size) { T.zero }

        # Subtract each element
        size.times do |i|
          new_data[i] = data[i] - other.data[i]
        end

        Array(T).new(shape.dup, new_data)
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # Shapes are compatible for broadcasting
        # Broadcast both arrays to the result shape
        broadcasted_self = Narray.broadcast(self, result_shape)
        broadcasted_other = Narray.broadcast(other, result_shape)

        # Subtract the broadcasted arrays
        new_data = ::Array(T).new(result_shape.product) { T.zero }

        result_shape.product.times do |i|
          new_data[i] = broadcasted_self.data[i] - broadcasted_other.data[i]
        end

        Array(T).new(result_shape, new_data)
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot subtract arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        # Subtract each element in-place
        size.times do |i|
          @data[i] -= other.data[i]
        end

        self
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # If the result shape is different from our shape, we need to create a new array
        # This is because we can't modify our shape in-place if broadcasting changes it
        if result_shape != shape
          # Create a new array with the broadcasted result
          broadcasted_self = Narray.broadcast(self, result_shape)
          broadcasted_other = Narray.broadcast(other, result_shape)

          # Subtract the broadcasted arrays
          result_shape.product.times do |i|
            broadcasted_self.data[i] -= broadcasted_other.data[i]
          end

          # Replace our data and shape with the new ones
          @data = broadcasted_self.data
          @shape = result_shape

          self
        else
          # Our shape is the result shape, so we can broadcast the other array to our shape
          broadcasted_other = Narray.broadcast(other, shape)

          # Subtract the broadcasted array from our data in-place
          size.times do |i|
            @data[i] -= broadcasted_other.data[i]
          end

          self
        end
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot subtract arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        new_data = ::Array(T).new(size) { T.zero }

        # Multiply each element
        size.times do |i|
          new_data[i] = data[i] * other.data[i]
        end

        Array(T).new(shape.dup, new_data)
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # Shapes are compatible for broadcasting
        # Broadcast both arrays to the result shape
        broadcasted_self = Narray.broadcast(self, result_shape)
        broadcasted_other = Narray.broadcast(other, result_shape)

        # Multiply the broadcasted arrays
        new_data = ::Array(T).new(result_shape.product) { T.zero }

        result_shape.product.times do |i|
          new_data[i] = broadcasted_self.data[i] * broadcasted_other.data[i]
        end

        Array(T).new(result_shape, new_data)
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot multiply arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        # Multiply each element in-place
        size.times do |i|
          @data[i] *= other.data[i]
        end

        self
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # If the result shape is different from our shape, we need to create a new array
        # This is because we can't modify our shape in-place if broadcasting changes it
        if result_shape != shape
          # Create a new array with the broadcasted result
          broadcasted_self = Narray.broadcast(self, result_shape)
          broadcasted_other = Narray.broadcast(other, result_shape)

          # Multiply the broadcasted arrays
          result_shape.product.times do |i|
            broadcasted_self.data[i] *= broadcasted_other.data[i]
          end

          # Replace our data and shape with the new ones
          @data = broadcasted_self.data
          @shape = result_shape

          self
        else
          # Our shape is the result shape, so we can broadcast the other array to our shape
          broadcasted_other = Narray.broadcast(other, shape)

          # Multiply the broadcasted array with our data in-place
          size.times do |i|
            @data[i] *= broadcasted_other.data[i]
          end

          self
        end
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot multiply arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        new_data = ::Array(T).new(size) { T.zero }

        # Divide each element
        size.times do |i|
          new_data[i] = T.new((data[i] / other.data[i]).to_f)
        end

        Array(T).new(shape.dup, new_data)
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # Shapes are compatible for broadcasting
        # Broadcast both arrays to the result shape
        broadcasted_self = Narray.broadcast(self, result_shape)
        broadcasted_other = Narray.broadcast(other, result_shape)

        # Divide the broadcasted arrays
        new_data = ::Array(T).new(result_shape.product) { T.zero }

        result_shape.product.times do |i|
          # Ensure floating point division by converting to Float64 first
          value = (broadcasted_self.data[i].to_f64 / broadcasted_other.data[i].to_f64)
          new_data[i] = T.new(value)
        end

        Array(T).new(result_shape, new_data)
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot divide arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
      # Check if shapes are compatible for broadcasting
      if shape == other.shape
        # Shapes match exactly, no broadcasting needed
        # Divide each element in-place
        size.times do |i|
          @data[i] = T.new((@data[i] / other.data[i]).to_f)
        end

        self
      elsif result_shape = Narray.broadcast_shapes(shape, other.shape)
        # If the result shape is different from our shape, we need to create a new array
        # This is because we can't modify our shape in-place if broadcasting changes it
        if result_shape != shape
          # Create a new array with the broadcasted result
          broadcasted_self = Narray.broadcast(self, result_shape)
          broadcasted_other = Narray.broadcast(other, result_shape)

          # Divide the broadcasted arrays
          result_shape.product.times do |i|
            # Ensure floating point division by converting to Float64 first
            value = (broadcasted_self.data[i].to_f64 / broadcasted_other.data[i].to_f64)
            broadcasted_self.data[i] = T.new(value)
          end

          # Replace our data and shape with the new ones
          @data = broadcasted_self.data
          @shape = result_shape

          self
        else
          # Our shape is the result shape, so we can broadcast the other array to our shape
          broadcasted_other = Narray.broadcast(other, shape)

          # Divide our data by the broadcasted array in-place
          size.times do |i|
            # Ensure floating point division by converting to Float64 first
            value = (@data[i].to_f64 / broadcasted_other.data[i].to_f64)
            @data[i] = T.new(value)
          end

          self
        end
      else
        # Shapes are not compatible for broadcasting
        raise ArgumentError.new("Cannot divide arrays with incompatible shapes: #{shape} and #{other.shape}")
      end
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
  def self.dot(a : Array(T), b : Array(U)) : Array(Float64) forall T, U
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
    new_data = ::Array(Float64).new(new_shape.product, 0.0)

    # Compute the dot product
    a_rows.times do |i|
      b_cols.times do |j|
        sum = 0.0
        a_cols.times do |k|
          sum += a[[i, k]].to_f64 * b[[k, j]].to_f64
        end
        new_data[i * b_cols + j] = sum
      end
    end

    Array(Float64).new(new_shape, new_data)
  end

  # Original dot product for same type (for backward compatibility)
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
  def self.matmul(a : Array(T), b : Array(U)) : Array(Float64) forall T, U
    dot(a, b)
  end

  # Original matmul for same type (for backward compatibility)
  def self.matmul(a : Array(T), b : Array(T)) : Array(T) forall T
    dot(a, b)
  end
end
