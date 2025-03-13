# Operations for NArray
module Narray
  class Array(T)
    # Reshapes the array to the new shape
    # The total number of elements must remain the same
    def reshape(new_shape : ::Array(Int32)) : Array(T)
      # Validate that the new shape has the same number of elements
      new_size = new_shape.product
      if new_size != size
        raise ArgumentError.new("Cannot reshape array of size #{size} into shape #{new_shape} with size #{new_size}")
      end

      # Create a new array with the same data but new shape
      Array(T).new(new_shape, data.dup)
    end

    # Reshapes the array to the new shape in-place
    # The total number of elements must remain the same
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

    # Returns the transpose of the array
    # For 1D arrays, this returns a copy of the array
    # For 2D arrays, this swaps rows and columns
    # For higher dimensions, this reverses the order of dimensions
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

    # Transposes the array in-place
    # For 1D arrays, this does nothing
    # For 2D arrays, this swaps rows and columns
    # For higher dimensions, this reverses the order of dimensions
    # Note: This method creates a new data array and updates the shape
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

  # Concatenates arrays along the specified axis
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

  # Stacks arrays vertically (along the first axis)
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

  # Stacks arrays horizontally (along the second axis)
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
end
