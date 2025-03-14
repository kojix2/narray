module Narray
  # Hyperbolic functions module
  module Math
    # Computes the hyperbolic sine of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # b = Narray::Math.sinh(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.5211, 1.1752, 3.6269] (approximately)
    # ```
    def self.sinh(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply sinh to each element
      arr.size.times do |i|
        new_data[i] = ::Math.sinh(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the hyperbolic sine of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # Narray::Math.sinh!(a)
    # a.data # => [0.0, 0.5211, 1.1752, 3.6269] (approximately)
    # ```
    def self.sinh!(arr : Array(T)) : Array(T) forall T
      # Apply sinh to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.sinh(arr.data[i].to_f))
      end

      arr
    end

    # Computes the hyperbolic cosine of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # b = Narray::Math.cosh(a)
    # b.shape # => [2, 2]
    # b.data  # => [1.0, 1.1276, 1.5431, 3.7622] (approximately)
    # ```
    def self.cosh(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply cosh to each element
      arr.size.times do |i|
        new_data[i] = ::Math.cosh(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the hyperbolic cosine of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # Narray::Math.cosh!(a)
    # a.data # => [1.0, 1.1276, 1.5431, 3.7622] (approximately)
    # ```
    def self.cosh!(arr : Array(T)) : Array(T) forall T
      # Apply cosh to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.cosh(arr.data[i].to_f))
      end

      arr
    end

    # Computes the hyperbolic tangent of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # b = Narray::Math.tanh(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.4621, 0.7616, 0.9640] (approximately)
    # ```
    def self.tanh(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply tanh to each element
      arr.size.times do |i|
        new_data[i] = ::Math.tanh(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the hyperbolic tangent of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 1.0, 2.0])
    # Narray::Math.tanh!(a)
    # a.data # => [0.0, 0.4621, 0.7616, 0.9640] (approximately)
    # ```
    def self.tanh!(arr : Array(T)) : Array(T) forall T
      # Apply tanh to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.tanh(arr.data[i].to_f))
      end

      arr
    end
  end
end
