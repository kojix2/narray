module Narray
  # Trigonometric functions module
  module Math
    # Computes the sine of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/2, Math::PI, 3*Math::PI/2])
    # b = Narray::Math.sin(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 1.0, 0.0, -1.0] (approximately)
    # ```
    def self.sin(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply sin to each element
      arr.size.times do |i|
        new_data[i] = ::Math.sin(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the sine of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/2, Math::PI, 3*Math::PI/2])
    # Narray::Math.sin!(a)
    # a.data # => [0.0, 1.0, 0.0, -1.0] (approximately)
    # ```
    def self.sin!(arr : Array(T)) : Array(T) forall T
      # Apply sin to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.sin(arr.data[i].to_f))
      end

      arr
    end

    # Computes the cosine of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/2, Math::PI, 3*Math::PI/2])
    # b = Narray::Math.cos(a)
    # b.shape # => [2, 2]
    # b.data  # => [1.0, 0.0, -1.0, 0.0] (approximately)
    # ```
    def self.cos(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply cos to each element
      arr.size.times do |i|
        new_data[i] = ::Math.cos(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the cosine of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/2, Math::PI, 3*Math::PI/2])
    # Narray::Math.cos!(a)
    # a.data # => [1.0, 0.0, -1.0, 0.0] (approximately)
    # ```
    def self.cos!(arr : Array(T)) : Array(T) forall T
      # Apply cos to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.cos(arr.data[i].to_f))
      end

      arr
    end

    # Computes the tangent of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/4, Math::PI/2 - 0.01, Math::PI])
    # b = Narray::Math.tan(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 1.0, very large value, 0.0] (approximately)
    # ```
    def self.tan(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply tan to each element
      arr.size.times do |i|
        new_data[i] = ::Math.tan(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the tangent of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, Math::PI/4, Math::PI/2 - 0.01, Math::PI])
    # Narray::Math.tan!(a)
    # a.data # => [0.0, 1.0, very large value, 0.0] (approximately)
    # ```
    def self.tan!(arr : Array(T)) : Array(T) forall T
      # Apply tan to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.tan(arr.data[i].to_f))
      end

      arr
    end

    # Computes the arc sine (inverse sine) of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 0.7071, 1.0])
    # b = Narray::Math.asin(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.5236, 0.7854, 1.5708] (approximately)
    # ```
    def self.asin(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply asin to each element
      arr.size.times do |i|
        new_data[i] = ::Math.asin(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the arc sine (inverse sine) of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 0.5, 0.7071, 1.0])
    # Narray::Math.asin!(a)
    # a.data # => [0.0, 0.5236, 0.7854, 1.5708] (approximately)
    # ```
    def self.asin!(arr : Array(T)) : Array(T) forall T
      # Apply asin to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.asin(arr.data[i].to_f))
      end

      arr
    end

    # Computes the arc cosine (inverse cosine) of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 0.7071, 0.5, 0.0])
    # b = Narray::Math.acos(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.7854, 1.0472, 1.5708] (approximately)
    # ```
    def self.acos(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply acos to each element
      arr.size.times do |i|
        new_data[i] = ::Math.acos(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the arc cosine (inverse cosine) of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [1.0, 0.7071, 0.5, 0.0])
    # Narray::Math.acos!(a)
    # a.data # => [0.0, 0.7854, 1.0472, 1.5708] (approximately)
    # ```
    def self.acos!(arr : Array(T)) : Array(T) forall T
      # Apply acos to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.acos(arr.data[i].to_f))
      end

      arr
    end

    # Computes the arc tangent (inverse tangent) of each element in the array.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 1.0, 1.7321, 10.0])
    # b = Narray::Math.atan(a)
    # b.shape # => [2, 2]
    # b.data  # => [0.0, 0.7854, 1.0472, 1.4711] (approximately)
    # ```
    def self.atan(arr : Array(T)) : Array(Float64) forall T
      # Create a new array with the same shape
      new_data = ::Array(Float64).new(arr.size) { 0.0 }

      # Apply atan to each element
      arr.size.times do |i|
        new_data[i] = ::Math.atan(arr.data[i].to_f)
      end

      Array(Float64).new(arr.shape.dup, new_data)
    end

    # Computes the arc tangent (inverse tangent) of each element in the array in-place.
    #
    # ```
    # a = Narray.array([2, 2], [0.0, 1.0, 1.7321, 10.0])
    # Narray::Math.atan!(a)
    # a.data # => [0.0, 0.7854, 1.0472, 1.4711] (approximately)
    # ```
    def self.atan!(arr : Array(T)) : Array(T) forall T
      # Apply atan to each element in-place
      arr.size.times do |i|
        arr.data[i] = T.new(::Math.atan(arr.data[i].to_f))
      end

      arr
    end
  end
end
