module Narray
  # Exponential and logarithmic functions module
  module Math
    # Computes the exponential of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
    # b = Narray::Math.exp(a)
    # b.shape # => [2, 2]
    # b.data  # => [1.0, 2.7183, 7.3891, 20.0855] (approximately)
    # ```
    def self.exp(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply exp to each element
      arr.size.times do |i|
        new_data[i] = ::Math.exp(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the exponential of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
    # Narray::Math.exp!(a)
    # a.data # => [1.0, 2.7183, 7.3891, 20.0855] (approximately)
    # ```
    def self.exp!(arr : Array(T)) : Array(T) forall T
      # Apply exp to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.exp(arr.data[i].to_f))
      end

      arr
    end

    # Computes the natural logarithm of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 2.0, 5.0, 10.0])
    # b = Narray::Math.log(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.6931, 1.6094, 2.3026] (approximately)
    # ```
    def self.log(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply log to each element
      arr.size.times do |i|
        new_data[i] = ::Math.log(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the natural logarithm of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 2.0, 5.0, 10.0])
    # Narray::Math.log!(a)
    # a.data # => [0.0, 0.6931, 1.6094, 2.3026] (approximately)
    # ```
    def self.log!(arr : Array(T)) : Array(T) forall T
      # Apply log to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.log(arr.data[i].to_f))
      end

      arr
    end

    # Computes the base-10 logarithm of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 10.0, 100.0, 1000.0])
    # b = Narray::Math.log10(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 1.0, 2.0, 3.0]
    # ```
    def self.log10(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply log10 to each element
      arr.size.times do |i|
        new_data[i] = ::Math.log10(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the base-10 logarithm of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 10.0, 100.0, 1000.0])
    # Narray::Math.log10!(a)
    # a.data # => [0.0, 1.0, 2.0, 3.0]
    # ```
    def self.log10!(arr : Array(T)) : Array(T) forall T
      # Apply log10 to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.log10(arr.data[i].to_f))
      end

      arr
    end

    # Computes the square root of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 4.0, 9.0, 16.0])
    # b = Narray::Math.sqrt(a)
    # b.shape # => [2, 2]
    # b.data  # => [1.0, 2.0, 3.0, 4.0]
    # ```
    def self.sqrt(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply sqrt to each element
      arr.size.times do |i|
        new_data[i] = ::Math.sqrt(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the square root of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 4.0, 9.0, 16.0])
    # Narray::Math.sqrt!(a)
    # a.data # => [1.0, 2.0, 3.0, 4.0]
    # ```
    def self.sqrt!(arr : Array(T)) : Array(T) forall T
      # Apply sqrt to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.sqrt(arr.data[i].to_f))
      end

      arr
    end

    # Raises each element of the array to the specified power.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 2.0, 3.0, 4.0])
    # b = Narray::Math.pow(a, 2)
    # b.shape # => [2, 2]
    # b.data  # => [1.0, 4.0, 9.0, 16.0]
    # ```
    def self.pow(arr : Array(T), power : Number) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply power to each element
      arr.size.times do |i|
        new_data[i] = arr.data[i].to_f ** power
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Raises each element of the array to the specified power in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 2.0, 3.0, 4.0])
    # Narray::Math.pow!(a, 2)
    # a.data # => [1.0, 4.0, 9.0, 16.0]
    # ```
    def self.pow!(arr : Array(T), power : Number) : Array(T) forall T
      # Apply power to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(arr.data[i].to_f ** power)
      end

      arr
    end
  end
end
