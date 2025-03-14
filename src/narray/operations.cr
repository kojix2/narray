# Operations for NArray
#
# This module provides various array manipulation operations for NArray, including:
# - Reshaping arrays (reshape, reshape!)
# - Transposing arrays (transpose, transpose!)
# - Concatenating arrays (concatenate, vstack, hstack)
# - Masking operations (mask, mask_set)
module Narray
  class Array(T)
    # Reshapes the array to the new shape.
    #
    # The total number of elements must remain the same.
    # Returns a new array with the same data but new shape.
    #
    # ```
    # arr = Narray.arange(0, 6)
    # reshaped = arr.reshape([2, 3])
    # reshaped.shape # => [2, 3]
    # reshaped.ndim  # => 2
    # reshaped.size  # => 6
    # reshaped.data  # => [0, 1, 2, 3, 4, 5]
    #
    # arr2 = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # reshaped2 = arr2.reshape([6])
    # reshaped2.shape # => [6]
    # reshaped2.ndim  # => 1
    # ```
    #
    # Raises `ArgumentError` if the new shape has a different number of elements.
    #
    # See also: `Array#reshape!`.
    def reshape(new_shape : ::Array(Int32)) : Array(T)
      # Validate that the new shape has the same number of elements
      new_size = new_shape.product
      if new_size != size
        raise ArgumentError.new("Cannot reshape array of size #{size} into shape #{new_shape} with size #{new_size}")
      end

      # Create a new array with the same data but new shape
      Array(T).new(new_shape, data.dup)
    end

    # Reshapes the array to the new shape in-place.
    #
    # The total number of elements must remain the same.
    # Modifies the array's shape in-place, keeping the same data.
    #
    # ```
    # arr = Narray.arange(0, 6)
    # arr.reshape!([2, 3])
    # arr.shape # => [2, 3]
    # arr.ndim  # => 2
    # arr.size  # => 6
    # arr.data  # => [0, 1, 2, 3, 4, 5]
    # ```
    #
    # Raises `ArgumentError` if the new shape has a different number of elements.
    #
    # See also: `Array#reshape`.
    def reshape!(new_shape : ::Array(Int32)) : self
      # Validate that the new shape has the same number of elements
      new_size = new_shape.product
      if new_size != size
        raise ArgumentError.new("Cannot reshape array of size #{size} into shape #{new_shape} with size #{new_size}")
      end

      # Update the shape in-place
      @shape = new_shape.dup
      self
    end

    # Returns the transpose of the array.
    #
    # For 1D arrays, this returns a copy of the array.
    # For 2D arrays, this swaps rows and columns.
    # For higher dimensions, this reverses the order of dimensions.
    #
    # ```
    # # 1D array
    # arr = Narray.arange(0, 3)
    # transposed = arr.transpose
    # transposed.shape # => [3]
    # transposed.data  # => [0, 1, 2]
    #
    # # 2D array
    # arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # transposed = arr.transpose
    # transposed.shape # => [3, 2]
    # transposed.data  # => [1, 4, 2, 5, 3, 6]
    #
    # # 3D array
    # arr = Narray.array([2, 2, 2], [1, 2, 3, 4, 5, 6, 7, 8])
    # transposed = arr.transpose
    # transposed.shape # => [2, 2, 2]
    # transposed.data  # => [1, 5, 3, 7, 2, 6, 4, 8]
    # ```
    #
    # See also: `Array#transpose!`.
    def transpose : Array(T)
      case ndim
      when 0, 1
        # For 0D or 1D arrays, just return a copy
        Array(T).new(shape.dup, data.dup)
      when 2
        # For 2D arrays, swap rows and columns
        rows, cols = shape
        new_shape = [cols, rows]
        new_data = ::Array(T).new(size) { T.zero }

        rows.times do |i|
          cols.times do |j|
            new_data[j * rows + i] = data[i * cols + j]
          end
        end

        Array(T).new(new_shape, new_data)
      else
        # For higher dimensions, reverse the order of dimensions
        new_shape = shape.reverse
        new_data = ::Array(T).new(size) { T.zero }

        # Create a mapping from old indices to new indices
        indices = ::Array(Int32).new(ndim, 0)
        size.times do |i|
          # Convert flat index to multi-dimensional indices
          flat_idx = i
          stride = 1
          indices.size.times do |dim|
            indices[dim] = (flat_idx // stride) % shape[dim]
            stride *= shape[dim]
          end

          # Reverse the indices for transposition
          reversed_indices = indices.reverse

          # Convert back to flat index for the new array
          new_flat_idx = 0
          stride = 1
          reversed_indices.size.times do |dim|
            new_flat_idx += reversed_indices[dim] * stride
            stride *= new_shape[dim]
          end

          new_data[new_flat_idx] = data[i]
        end

        Array(T).new(new_shape, new_data)
      end
    end

    # Transposes the array in-place.
    #
    # For 1D arrays, this does nothing.
    # For 2D arrays, this swaps rows and columns.
    # For higher dimensions, this reverses the order of dimensions.
    # Note: This method creates a new data array and updates the shape.
    #
    # ```
    # # 1D array - no change
    # arr = Narray.arange(0, 3)
    # arr.transpose!
    # arr.shape # => [3]
    # arr.data  # => [0, 1, 2]
    #
    # # 2D array
    # arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
    # arr.transpose!
    # arr.shape # => [3, 2]
    # arr.data  # => [1, 4, 2, 5, 3, 6]
    # ```
    #
    # See also: `Array#transpose`.
    def transpose! : self
      case ndim
      when 0, 1
        # For 0D or 1D arrays, do nothing
        return self
      when 2
        # For 2D arrays, swap rows and columns
        rows, cols = shape
        new_shape = [cols, rows]
        new_data = ::Array(T).new(size) { T.zero }

        rows.times do |i|
          cols.times do |j|
            new_data[j * rows + i] = data[i * cols + j]
          end
        end

        @shape = new_shape
        @data = new_data
      else
        # For higher dimensions, reverse the order of dimensions
        new_shape = shape.reverse
        new_data = ::Array(T).new(size) { T.zero }

        # Create a mapping from old indices to new indices
        indices = ::Array(Int32).new(ndim, 0)
        size.times do |i|
          # Convert flat index to multi-dimensional indices
          flat_idx = i
          stride = 1
          indices.size.times do |dim|
            indices[dim] = (flat_idx // stride) % shape[dim]
            stride *= shape[dim]
          end

          # Reverse the indices for transposition
          reversed_indices = indices.reverse

          # Convert back to flat index for the new array
          new_flat_idx = 0
          stride = 1
          reversed_indices.size.times do |dim|
            new_flat_idx += reversed_indices[dim] * stride
            stride *= new_shape[dim]
          end

          new_data[new_flat_idx] = data[i]
        end

        @shape = new_shape
        @data = new_data
      end

      self
    end
  end

  class Array(T)
    # Returns a new array containing only the elements where the mask is true.
    #
    # The mask must be a boolean array with the same shape as the original array.
    # The result is a 1D array containing only the elements where the mask is true.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = Narray.array([5], [true, false, true, false, true])
    # result = arr.mask(mask)
    # result.shape # => [3]
    # result.data  # => [1, 3, 5]
    # ```
    #
    # Raises `ArgumentError` if the mask shape does not match the array shape.
    #
    # See also: `Array#mask_set`, `Array#mask(&block)`.
    def mask(mask : Array(Bool)) : Array(T)
      # Validate that the mask shape matches the array shape
      if mask.shape != shape
        raise ArgumentError.new("Mask shape #{mask.shape} does not match array shape #{shape}")
      end

      # Count the number of true values in the mask
      true_count = mask.data.count { |v| v }

      # Create a new array to hold the masked values
      new_data = ::Array(T).new(true_count)

      # Copy the values where the mask is true
      size.times do |i|
        if mask.data[i]
          new_data << data[i]
        end
      end

      # Return a new 1D array with the masked values
      Array(T).new([true_count], new_data)
    end

    # Returns a new array containing only the elements that satisfy the given condition.
    #
    # The condition is specified as a block that takes an element and returns a boolean.
    # The result is a 1D array containing only the elements where the block returns true.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # result = arr.mask { |x| x > 2 }
    # result.shape # => [3]
    # result.data  # => [3, 4, 5]
    # ```
    #
    # See also: `Array#mask(mask)`, `Array#mask_set`.
    def mask(&block : T -> Bool) : Array(T)
      # Create a boolean mask based on the block
      mask_data = ::Array(Bool).new(size)
      data.each do |value|
        mask_data << block.call(value)
      end
      mask_array = Array(Bool).new(shape.dup, mask_data)

      # Use the mask method to get the result
      mask(mask_array)
    end

    # Updates elements in the array where the mask is true with the given value.
    #
    # The mask must be a boolean array with the same shape as the original array.
    # The array is modified in-place.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = Narray.array([5], [true, false, true, false, true])
    # arr.mask_set(mask, 0)
    # arr.data # => [0, 2, 0, 4, 0]
    # ```
    #
    # Raises `ArgumentError` if the mask shape does not match the array shape.
    #
    # See also: `Array#mask`, `Array#mask_set(&block)`.
    def mask_set(mask : Array(Bool), value : T) : self
      # Validate that the mask shape matches the array shape
      if mask.shape != shape
        raise ArgumentError.new("Mask shape #{mask.shape} does not match array shape #{shape}")
      end

      # Update the values where the mask is true
      size.times do |i|
        if mask.data[i]
          @data[i] = value
        end
      end

      self
    end

    # Updates elements in the array where the mask is true with values from another array.
    #
    # The mask must be a boolean array with the same shape as the original array.
    # The values array must have the same number of elements as there are true values in the mask.
    # The array is modified in-place.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = Narray.array([5], [true, false, true, false, true])
    # values = Narray.array([3], [10, 20, 30])
    # arr.mask_set(mask, values)
    # arr.data # => [10, 2, 20, 4, 30]
    # ```
    #
    # Raises `ArgumentError` if the mask shape does not match the array shape.
    # Raises `ArgumentError` if the values array does not have the correct number of elements.
    #
    # See also: `Array#mask`, `Array#mask_set(mask, value)`.
    def mask_set(mask : Array(Bool), values : Array(T)) : self
      # Validate that the mask shape matches the array shape
      if mask.shape != shape
        raise ArgumentError.new("Mask shape #{mask.shape} does not match array shape #{shape}")
      end

      # Count the number of true values in the mask
      true_count = mask.data.count { |v| v }

      # Validate that the values array has the correct number of elements
      if values.size != true_count
        raise ArgumentError.new("Values array size (#{values.size}) does not match the number of true values in the mask (#{true_count})")
      end

      # Update the values where the mask is true
      value_index = 0
      size.times do |i|
        if mask.data[i]
          @data[i] = values.data[value_index]
          value_index += 1
        end
      end

      self
    end

    # Updates elements in the array that satisfy the given condition with the given value.
    #
    # The condition is specified as a block that takes an element and returns a boolean.
    # The array is modified in-place.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # arr.mask_set(0) { |x| x > 2 }
    # arr.data # => [1, 2, 0, 0, 0]
    # ```
    #
    # See also: `Array#mask`, `Array#mask_set(mask, value)`.
    def mask_set(value : T, &block : T -> Bool) : self
      # Create a boolean mask based on the block
      mask_data = ::Array(Bool).new(size)
      data.each do |val|
        mask_data << block.call(val)
      end
      mask_array = Array(Bool).new(shape.dup, mask_data)

      # Use the mask_set method to update the values
      mask_set(mask_array, value)
    end
  end

  # Concatenates arrays along the specified axis.
  #
  # The arrays must have the same shape except for the dimension corresponding to axis.
  #
  # ```
  # # 1D arrays
  # a = Narray.array([3], [1, 2, 3])
  # b = Narray.array([3], [4, 5, 6])
  # c = Narray.concatenate([a, b])
  # c.shape # => [6]
  # c.data  # => [1, 2, 3, 4, 5, 6]
  #
  # # 2D arrays along axis 0 (rows)
  # a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
  # b = Narray.array([1, 3], [7, 8, 9])
  # c = Narray.concatenate([a, b])
  # c.shape # => [3, 3]
  # c.data  # => [1, 2, 3, 4, 5, 6, 7, 8, 9]
  #
  # # 2D arrays along axis 1 (columns)
  # a = Narray.array([2, 2], [1, 2, 3, 4])
  # b = Narray.array([2, 3], [5, 6, 7, 8, 9, 10])
  # c = Narray.concatenate([a, b], 1)
  # c.shape # => [2, 5]
  # c.data  # => [1, 2, 5, 6, 7, 3, 4, 8, 9, 10]
  # ```
  #
  # Raises `ArgumentError` if:
  # - The array of arrays is empty
  # - The axis is out of bounds
  # - The arrays have different numbers of dimensions
  # - The arrays have different shapes except for the concatenation axis
  #
  # See also: `Narray.vstack`, `Narray.hstack`.
  def self.concatenate(arrays : ::Array(Array(T)), axis = 0) : Array(T) forall T
    # Validate that all arrays have the same shape except for the concatenation axis
    if arrays.empty?
      raise ArgumentError.new("Cannot concatenate empty array of arrays")
    end

    first_shape = arrays.first.shape
    ndim = first_shape.size

    if axis < 0 || axis >= ndim
      raise ArgumentError.new("Axis #{axis} is out of bounds for arrays with #{ndim} dimensions")
    end

    arrays.each do |arr|
      if arr.ndim != ndim
        raise ArgumentError.new("All arrays must have the same number of dimensions")
      end

      ndim.times do |dim|
        if dim != axis && arr.shape[dim] != first_shape[dim]
          raise ArgumentError.new("All arrays must have the same shape except for the concatenation axis")
        end
      end
    end

    # Calculate the new shape
    new_shape = first_shape.dup
    new_shape[axis] = arrays.sum(&.shape[axis])

    # Create a new array to hold the concatenated data
    new_size = new_shape.product
    new_data = ::Array(T).new(new_size) { T.zero }

    # Special case for 1D arrays
    if ndim == 1
      offset = 0
      arrays.each do |arr|
        arr.size.times do |i|
          new_data[offset + i] = arr.data[i]
        end
        offset += arr.size
      end
      return Array(T).new(new_shape, new_data)
    end

    # Special case for 2D arrays
    if ndim == 2
      if axis == 0
        # Concatenate along rows
        row_offset = 0
        arrays.each do |arr|
          rows, cols = arr.shape
          rows.times do |i|
            cols.times do |j|
              new_data[(row_offset + i) * new_shape[1] + j] = arr.data[i * cols + j]
            end
          end
          row_offset += rows
        end
      else # axis == 1
        # Concatenate along columns
        col_offset = 0
        arrays.each do |arr|
          rows, cols = arr.shape
          rows.times do |i|
            cols.times do |j|
              new_data[i * new_shape[1] + col_offset + j] = arr.data[i * cols + j]
            end
          end
          col_offset += cols
        end
      end
      return Array(T).new(new_shape, new_data)
    end

    # General case for higher dimensions
    # This is a simplified implementation that may not work correctly for all cases
    offset = 0
    arrays.each do |arr|
      # Calculate the size of each chunk to copy
      chunk_size = arr.shape[axis]

      # Calculate the stride for the concatenation axis
      stride = 1
      (0...axis).each do |dim|
        stride *= first_shape[dim]
      end

      # Calculate the number of chunks
      num_chunks = arr.size // (chunk_size * stride)

      # Copy each chunk
      num_chunks.times do |chunk|
        chunk_size.times do |i|
          idx = chunk * chunk_size * stride + i * stride
          new_idx = chunk * new_shape[axis] * stride + (offset + i) * stride

          stride.times do |j|
            new_data[new_idx + j] = arr.data[idx + j]
          end
        end
      end

      offset += chunk_size
    end

    Array(T).new(new_shape, new_data)
  end

  # Stacks arrays vertically (along the first axis).
  #
  # For 1D arrays, this converts them to 2D arrays with one row each.
  # For higher dimensions, this is equivalent to `concatenate(arrays, 0)`.
  #
  # ```
  # # 1D arrays
  # a = Narray.array([3], [1, 2, 3])
  # b = Narray.array([3], [4, 5, 6])
  # c = Narray.vstack([a, b])
  # c.shape # => [2, 3]
  # c.data  # => [1, 2, 3, 4, 5, 6]
  #
  # # 2D arrays
  # a = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
  # b = Narray.array([1, 3], [7, 8, 9])
  # c = Narray.vstack([a, b])
  # c.shape # => [3, 3]
  # c.data  # => [1, 2, 3, 4, 5, 6, 7, 8, 9]
  # ```
  #
  # See also: `Narray.hstack`, `Narray.concatenate`.
  def self.vstack(arrays : ::Array(Array(T))) : Array(T) forall T
    # For 1D arrays, convert to 2D arrays with one row each
    if arrays.first.ndim == 1
      # Create a new 2D array with shape [arrays.size, arrays.first.size]
      new_shape = [arrays.size, arrays.first.size]
      new_data = ::Array(T).new(new_shape.product) { T.zero }

      # Copy data from each array
      arrays.each_with_index do |arr, i|
        arr.size.times do |j|
          new_data[i * arr.size + j] = arr.data[j]
        end
      end

      return Array(T).new(new_shape, new_data)
    end

    # For higher dimensions, use concatenate
    concatenate(arrays, 0)
  end

  # Stacks arrays horizontally (along the second axis).
  #
  # For 1D arrays, this concatenates them along the first axis.
  # For 2D arrays, this concatenates them along the second axis (columns).
  # For higher dimensions, this is equivalent to `concatenate(arrays, 1)`.
  #
  # ```
  # # 1D arrays
  # a = Narray.array([3], [1, 2, 3])
  # b = Narray.array([3], [4, 5, 6])
  # c = Narray.hstack([a, b])
  # c.shape # => [6]
  # c.data  # => [1, 2, 3, 4, 5, 6]
  #
  # # 2D arrays
  # a = Narray.array([2, 2], [1, 2, 3, 4])
  # b = Narray.array([2, 3], [5, 6, 7, 8, 9, 10])
  # c = Narray.hstack([a, b])
  # c.shape # => [2, 5]
  # c.data  # => [1, 2, 5, 6, 7, 3, 4, 8, 9, 10]
  # ```
  #
  # See also: `Narray.vstack`, `Narray.concatenate`.
  def self.hstack(arrays : ::Array(Array(T))) : Array(T) forall T
    # For 1D arrays, concatenate along the first axis
    if arrays.first.ndim == 1
      concatenate(arrays, 0)
    else
      # For 2D arrays, create a special case to ensure correct ordering
      if arrays.first.ndim == 2
        # Get the total number of rows and columns
        rows = arrays.first.shape[0]
        total_cols = arrays.sum(&.shape[1])

        # Create a new array with shape [rows, total_cols]
        new_shape = [rows, total_cols]
        new_data = ::Array(T).new(new_shape.product) { T.zero }

        # Copy data from each array
        col_offset = 0
        arrays.each do |arr|
          arr_rows, arr_cols = arr.shape
          arr_rows.times do |i|
            arr_cols.times do |j|
              new_data[i * total_cols + col_offset + j] = arr.data[i * arr_cols + j]
            end
          end
          col_offset += arr_cols
        end

        return Array(T).new(new_shape, new_data)
      else
        # For higher dimensions, use concatenate
        concatenate(arrays, 1)
      end
    end
  end

  class Array(T)
    # Returns a boolean mask for equality with a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 2, 1])
    # mask = arr.eq(2)
    # mask.data # => [false, true, false, true, false]
    # ```
    #
    # See also: `Array#ne`, `Array#==`.
    def eq(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem == value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for equality with another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [1, 3, 3])
    # mask = a.eq(b)
    # mask.data # => [true, false, true]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#ne`, `Array#==`.
    def eq(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] == b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Returns a boolean mask for inequality with a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 2, 1])
    # mask = arr.ne(2)
    # mask.data # => [true, false, true, false, true]
    # ```
    #
    # See also: `Array#eq`, `Array#!=`.
    def ne(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem != value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for inequality with another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [1, 3, 3])
    # mask = a.ne(b)
    # mask.data # => [false, true, false]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#eq`, `Array#!=`.
    def ne(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] != b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Returns a boolean mask for greater than a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = arr.gt(3)
    # mask.data # => [false, false, false, true, true]
    # ```
    #
    # See also: `Array#ge`, `Array#>`.
    def gt(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem > value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for greater than another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [0, 2, 4])
    # mask = a.gt(b)
    # mask.data # => [true, false, false]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#ge`, `Array#>`.
    def gt(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] > b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Returns a boolean mask for greater than or equal to a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = arr.ge(3)
    # mask.data # => [false, false, true, true, true]
    # ```
    #
    # See also: `Array#gt`, `Array#>=`.
    def ge(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem >= value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for greater than or equal to another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [0, 2, 4])
    # mask = a.ge(b)
    # mask.data # => [true, true, false]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#gt`, `Array#>=`.
    def ge(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] >= b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Returns a boolean mask for less than a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = arr.lt(3)
    # mask.data # => [true, true, false, false, false]
    # ```
    #
    # See also: `Array#le`, `Array#<`.
    def lt(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem < value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for less than another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [0, 2, 4])
    # mask = a.lt(b)
    # mask.data # => [false, false, true]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#le`, `Array#<`.
    def lt(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] < b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Returns a boolean mask for less than or equal to a value.
    #
    # ```
    # arr = Narray.array([5], [1, 2, 3, 4, 5])
    # mask = arr.le(3)
    # mask.data # => [true, true, true, false, false]
    # ```
    #
    # See also: `Array#lt`, `Array#<=`.
    def le(value : T) : Array(Bool)
      result_data = ::Array(Bool).new(size)
      data.each do |elem|
        result_data << (elem <= value)
      end
      Array(Bool).new(shape.dup, result_data)
    end

    # Returns a boolean mask for less than or equal to another array.
    #
    # The arrays must be broadcast compatible.
    #
    # ```
    # a = Narray.array([3], [1, 2, 3])
    # b = Narray.array([3], [0, 2, 4])
    # mask = a.le(b)
    # mask.data # => [false, true, true]
    # ```
    #
    # Raises `ArgumentError` if the arrays cannot be broadcast together.
    #
    # See also: `Array#lt`, `Array#<=`.
    def le(other : Array(T)) : Array(Bool)
      # Get the broadcast shape
      broadcast_shape = Narray.broadcast_shapes(shape, other.shape)
      if broadcast_shape.nil?
        raise ArgumentError.new("Cannot broadcast arrays with shapes #{shape} and #{other.shape}")
      end

      # Broadcast both arrays to the same shape
      a = self.broadcast_to(broadcast_shape)
      b = other.broadcast_to(broadcast_shape)

      # Compare elements
      result_data = ::Array(Bool).new(a.size)
      a.size.times do |i|
        result_data << (a.data[i] <= b.data[i])
      end

      Array(Bool).new(broadcast_shape, result_data)
    end

    # Operator overloads for comparison operations

    # Equality operator (==)
    def ==(other : Array(T)) : Array(Bool)
      eq(other)
    end

    # Inequality operator (!=)
    def !=(other : Array(T)) : Array(Bool)
      ne(other)
    end

    # Greater than operator (>)
    def >(other : Array(T)) : Array(Bool)
      gt(other)
    end

    # Greater than or equal to operator (>=)
    def >=(other : Array(T)) : Array(Bool)
      ge(other)
    end

    # Less than operator (<)
    def <(other : Array(T)) : Array(Bool)
      lt(other)
    end

    # Less than or equal to operator (<=)
    def <=(other : Array(T)) : Array(Bool)
      le(other)
    end

    # Equality operator (==) with scalar
    def ==(value : T) : Array(Bool)
      eq(value)
    end

    # Inequality operator (!=) with scalar
    def !=(value : T) : Array(Bool)
      ne(value)
    end

    # Greater than operator (>) with scalar
    def >(value : T) : Array(Bool)
      gt(value)
    end

    # Greater than or equal to operator (>=) with scalar
    def >=(value : T) : Array(Bool)
      ge(value)
    end

    # Less than operator (<) with scalar
    def <(value : T) : Array(Bool)
      lt(value)
    end

    # Less than or equal to operator (<=) with scalar
    def <=(value : T) : Array(Bool)
      le(value)
    end
  end
end
