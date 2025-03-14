# Include mathematical function modules
require "./math/trig"
require "./math/hyperbolic"
require "./math/exponential"

# Mathematical operations for NArray
#
# This module provides various mathematical operations for NArray, including:
# - Element-wise arithmetic operations (+, -, *, /)
# - In-place arithmetic operations (add!, subtract!, multiply!, divide!)
# - Statistical functions (sum, mean, min, max, std)
# - Matrix operations (dot, matmul)
# - Mathematical functions (sin, cos, tan, etc.)
module Narray
  class Array(T)
    # Performs element-wise addition of two arrays.
    #
    # If the shapes match exactly, adds corresponding elements.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then adds corresponding elements.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = Narray.array([2, 2], [5, 6, 7, 8])
    # c = a + b
    # c.shape # => [2, 2]
    # c.data  # => [6, 8, 10, 12]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [1, 2])
    # b = Narray.array([1, 3], [3, 4, 5])
    # c = a + b
    # c.shape # => [2, 3]
    # c.data  # => [4, 5, 6, 5, 6, 7]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#add!`, `Array#-`.
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

    # Performs element-wise addition of an array and a scalar.
    #
    # Adds the scalar to each element of the array.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = a + 5
    # b.shape # => [2, 2]
    # b.data  # => [6, 7, 8, 9]
    # ```
    #
    # See also: `Array#add!`, `Array#-`.
    def +(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Add scalar to each element
      size.times do |i|
        new_data[i] = data[i] + T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Performs element-wise addition of two arrays in-place.
    #
    # If the shapes match exactly, adds corresponding elements in-place.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then adds corresponding elements in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = Narray.array([2, 2], [5, 6, 7, 8])
    # a.add!(b)
    # a.data # => [6, 8, 10, 12]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [1, 2])
    # b = Narray.array([1, 3], [3, 4, 5])
    # a.add!(b)
    # a.shape # => [2, 3]
    # a.data  # => [4, 5, 6, 5, 6, 7]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#+`, `Array#subtract!`.
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

    # Performs element-wise addition of an array and a scalar in-place.
    #
    # Adds the scalar to each element of the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # a.add!(5)
    # a.data # => [6, 7, 8, 9]
    # ```
    #
    # See also: `Array#+`, `Array#subtract!`.
    def add!(scalar : Number) : self
      # Add scalar to each element in-place
      size.times do |i|
        @data[i] += T.new(scalar)
      end

      self
    end

    # Performs element-wise subtraction of two arrays.
    #
    # If the shapes match exactly, subtracts corresponding elements.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then subtracts corresponding elements.
    #
    # ```
    # a = Narray.array([2, 2], [5, 6, 7, 8])
    # b = Narray.array([2, 2], [1, 2, 3, 4])
    # c = a - b
    # c.shape # => [2, 2]
    # c.data  # => [4, 4, 4, 4]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [5, 10])
    # b = Narray.array([1, 3], [1, 2, 3])
    # c = a - b
    # c.shape # => [2, 3]
    # c.data  # => [4, 3, 2, 9, 8, 7]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#subtract!`, `Array#+`.
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

    # Performs element-wise subtraction of an array and a scalar.
    #
    # Subtracts the scalar from each element of the array.
    #
    # ```
    # a = Narray.array([2, 2], [5, 6, 7, 8])
    # b = a - 3
    # b.shape # => [2, 2]
    # b.data  # => [2, 3, 4, 5]
    # ```
    #
    # See also: `Array#subtract!`, `Array#+`.
    def -(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Subtract scalar from each element
      size.times do |i|
        new_data[i] = data[i] - T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Performs element-wise subtraction of two arrays in-place.
    #
    # If the shapes match exactly, subtracts corresponding elements in-place.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then subtracts corresponding elements in-place.
    #
    # ```
    # a = Narray.array([2, 2], [5, 6, 7, 8])
    # b = Narray.array([2, 2], [1, 2, 3, 4])
    # a.subtract!(b)
    # a.data # => [4, 4, 4, 4]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [5, 10])
    # b = Narray.array([1, 3], [1, 2, 3])
    # a.subtract!(b)
    # a.shape # => [2, 3]
    # a.data  # => [4, 3, 2, 9, 8, 7]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#-`, `Array#add!`.
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

    # Performs element-wise subtraction of an array and a scalar in-place.
    #
    # Subtracts the scalar from each element of the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [5, 6, 7, 8])
    # a.subtract!(3)
    # a.data # => [2, 3, 4, 5]
    # ```
    #
    # See also: `Array#-`, `Array#add!`.
    def subtract!(scalar : Number) : self
      # Subtract scalar from each element in-place
      size.times do |i|
        @data[i] -= T.new(scalar)
      end

      self
    end

    # Performs element-wise multiplication of two arrays.
    #
    # If the shapes match exactly, multiplies corresponding elements.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then multiplies corresponding elements.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = Narray.array([2, 2], [5, 6, 7, 8])
    # c = a * b
    # c.shape # => [2, 2]
    # c.data  # => [5, 12, 21, 32]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [2, 3])
    # b = Narray.array([1, 3], [1, 2, 3])
    # c = a * b
    # c.shape # => [2, 3]
    # c.data  # => [2, 4, 6, 3, 6, 9]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#multiply!`, `Array#/`.
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

    # Performs element-wise multiplication of an array and a scalar.
    #
    # Multiplies each element of the array by the scalar.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = a * 2
    # b.shape # => [2, 2]
    # b.data  # => [2, 4, 6, 8]
    # ```
    #
    # See also: `Array#multiply!`, `Array#/`.
    def *(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Multiply each element by scalar
      size.times do |i|
        new_data[i] = data[i] * T.new(scalar)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Performs element-wise multiplication of two arrays in-place.
    #
    # If the shapes match exactly, multiplies corresponding elements in-place.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then multiplies corresponding elements in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = Narray.array([2, 2], [5, 6, 7, 8])
    # a.multiply!(b)
    # a.data # => [5, 12, 21, 32]
    #
    # # Broadcasting example
    # a = Narray.array([2, 1], [2, 3])
    # b = Narray.array([1, 3], [1, 2, 3])
    # a.multiply!(b)
    # a.shape # => [2, 3]
    # a.data  # => [2, 4, 6, 3, 6, 9]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#*`, `Array#divide!`.
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

    # Performs element-wise multiplication of an array and a scalar in-place.
    #
    # Multiplies each element of the array by the scalar in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # a.multiply!(2)
    # a.data # => [2, 4, 6, 8]
    # ```
    #
    # See also: `Array#*`, `Array#divide!`.
    def multiply!(scalar : Number) : self
      # Multiply each element by scalar in-place
      size.times do |i|
        @data[i] *= T.new(scalar)
      end

      self
    end

    # Performs element-wise division of two arrays.
    #
    # If the shapes match exactly, divides corresponding elements.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then divides corresponding elements.
    #
    # ```
    # a = Narray.array([2, 2], [10, 12, 14, 16])
    # b = Narray.array([2, 2], [2, 3, 2, 4])
    # c = a / b
    # c.shape # => [2, 2]
    # c.data  # => [5, 4, 7, 4]
    #
    # # Broadcasting example with floating-point division
    # a = Narray.array([2, 1], [6.0, 9.0])
    # b = Narray.array([1, 3], [1.0, 2.0, 3.0])
    # c = a / b
    # c.shape # => [2, 3]
    # c.data  # => [6.0, 3.0, 2.0, 9.0, 4.5, 3.0]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#divide!`, `Array#*`.
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

    # Performs element-wise division of an array and a scalar.
    #
    # Divides each element of the array by the scalar.
    #
    # ```
    # a = Narray.array([2, 2], [2, 4, 6, 8])
    # b = a / 2
    # b.shape # => [2, 2]
    # b.data  # => [1, 2, 3, 4]
    # ```
    #
    # See also: `Array#divide!`, `Array#*`.
    def /(scalar : Number) : Array(T)
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Divide each element by scalar
      size.times do |i|
        new_data[i] = T.new((data[i] / T.new(scalar)).to_f)
      end

      Array(T).new(shape.dup, new_data)
    end

    # Performs element-wise division of two arrays in-place.
    #
    # If the shapes match exactly, divides corresponding elements in-place.
    # If the shapes are compatible for broadcasting, broadcasts the arrays to a common shape
    # and then divides corresponding elements in-place.
    #
    # ```
    # a = Narray.array([2, 2], [10, 12, 14, 16])
    # b = Narray.array([2, 2], [2, 3, 2, 4])
    # a.divide!(b)
    # a.data # => [5, 4, 7, 4]
    #
    # # Broadcasting example with floating-point division
    # a = Narray.array([2, 1], [6.0, 9.0])
    # b = Narray.array([1, 3], [1.0, 2.0, 3.0])
    # a.divide!(b)
    # a.shape # => [2, 3]
    # a.data  # => [6.0, 3.0, 2.0, 9.0, 4.5, 3.0]
    # ```
    #
    # Raises `ArgumentError` if the shapes are not compatible for broadcasting.
    #
    # See also: `Array#/`, `Array#multiply!`.
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

    # Performs element-wise division of an array and a scalar in-place.
    #
    # Divides each element of the array by the scalar in-place.
    #
    # ```
    # a = Narray.array([2, 2], [2, 4, 6, 8])
    # a.divide!(2)
    # a.data # => [1, 2, 3, 4]
    # ```
    #
    # See also: `Array#/`, `Array#multiply!`.
    def divide!(scalar : Number) : self
      # Divide each element by scalar in-place
      size.times do |i|
        @data[i] = T.new((@data[i] / T.new(scalar)).to_f)
      end

      self
    end

    # Performs element-wise negation of an array.
    #
    # Returns a new array with each element negated.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # b = -a
    # b.shape # => [2, 2]
    # b.data  # => [-1, -2, -3, -4]
    # ```
    def -
      # Create a new array with the same shape
      new_data = ::Array(T).new(size) { T.zero }

      # Negate each element
      size.times do |i|
        new_data[i] = T.new(-data[i])
      end

      Array(T).new(shape.dup, new_data)
    end

    # Computes the sum of all elements in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # a.sum # => 10
    # ```
    #
    # See also: `Array#mean`, `Array#min`, `Array#max`.
    def sum : T
      data.sum
    end

    # Computes the mean (average) of all elements in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # a.mean # => 2.5
    # ```
    #
    # See also: `Array#sum`, `Array#std`.
    def mean : Float64
      sum.to_f / size
    end

    # Returns the minimum value in the array.
    #
    # ```
    # a = Narray.array([2, 2], [3, 1, 4, 2])
    # a.min # => 1
    # ```
    #
    # See also: `Array#max`, `Array#sum`.
    def min : T
      data.min
    end

    # Returns the maximum value in the array.
    #
    # ```
    # a = Narray.array([2, 2], [3, 1, 4, 2])
    # a.max # => 4
    # ```
    #
    # See also: `Array#min`, `Array#sum`.
    def max : T
      data.max
    end

    # Computes the standard deviation of all elements in the array.
    #
    # The standard deviation is a measure of the amount of variation or dispersion of a set of values.
    # A low standard deviation indicates that the values tend to be close to the mean,
    # while a high standard deviation indicates that the values are spread out over a wider range.
    #
    # ```
    # a = Narray.array([2, 2], [1, 2, 3, 4])
    # a.std # => 1.118... (approximately)
    # ```
    #
    # See also: `Array#mean`, `Array#sum`.
    def std : Float64
      m = mean
      variance = data.sum { |x| (x.to_f - m) ** 2 } / size
      ::Math.sqrt(variance)
    end
  end

  # Computes the matrix multiplication (dot product) of two matrices.
  #
  # For 2D arrays, this is the standard matrix multiplication.
  # The inner dimensions must match: if a has shape [m, n] and b has shape [n, p],
  # the result will have shape [m, p].
  #
  # ```
  # a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
  # b = Narray.array([3, 2], [7, 8, 9, 10, 11, 12])
  # c = Narray.dot(a, b)
  # c.shape # => [2, 2]
  # c.data  # => [58, 64, 139, 154]
  # ```
  #
  # Raises `ArgumentError` if the arrays are not 2-dimensional or if the inner dimensions don't match.
  #
  # See also: `Narray.matmul`.
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
