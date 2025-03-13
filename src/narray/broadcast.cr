# Broadcasting functionality for NArray
module Narray
  # Checks if two shapes are broadcast compatible
  # Returns the resulting shape if compatible, nil otherwise
  def self.broadcast_shapes(shape1 : ::Array(Int32), shape2 : ::Array(Int32)) : ::Array(Int32)?
    # Get the number of dimensions for each shape
    ndim1 = shape1.size
    ndim2 = shape2.size

    # The result will have the maximum number of dimensions
    result_ndim = Math.max(ndim1, ndim2)
    result_shape = ::Array(Int32).new(result_ndim, 0)

    # Iterate through dimensions from right to left
    (0...result_ndim).each do |i|
      # Get the dimension sizes, or 1 if the dimension doesn't exist
      dim1 = i < ndim1 ? shape1[ndim1 - 1 - i] : 1
      dim2 = i < ndim2 ? shape2[ndim2 - 1 - i] : 1

      # If dimensions are the same, use that size
      # If one is 1, use the other size (broadcasting)
      # If neither condition is met, shapes are not compatible
      if dim1 == dim2
        result_shape[result_ndim - 1 - i] = dim1
      elsif dim1 == 1
        result_shape[result_ndim - 1 - i] = dim2
      elsif dim2 == 1
        result_shape[result_ndim - 1 - i] = dim1
      else
        # Shapes are not compatible for broadcasting
        return nil
      end
    end

    result_shape
  end

  # Broadcasts an array to a new shape
  # The new shape must be broadcast compatible with the original shape
  def self.broadcast(array : Array(T), new_shape : ::Array(Int32)) : Array(T) forall T
    # If shapes are already the same, return the original array
    if array.shape == new_shape
      return array
    end

    # Check if broadcasting is possible
    unless can_broadcast?(array.shape, new_shape)
      raise ArgumentError.new("Cannot broadcast array with shape #{array.shape} to shape #{new_shape}")
    end

    # Create a new array with the new shape
    new_size = new_shape.product
    new_data = ::Array(T).new(new_size) { T.zero }

    # Fill the new array with broadcasted values
    # This is a bit complex because we need to handle arbitrary dimensions
    # We'll use a helper method to calculate the source index for each target index
    new_shape.product.times do |i|
      # Convert flat index to multi-dimensional indices for the new shape
      target_indices = flat_index_to_indices(i, new_shape)

      # Calculate the corresponding source indices in the original array
      source_indices = broadcast_indices(target_indices, array.shape)

      # Get the value from the source array
      source_flat_index = indices_to_flat_index(source_indices, array.shape)
      new_data[i] = array.data[source_flat_index]
    end

    Array(T).new(new_shape, new_data)
  end

  # Checks if a shape can be broadcast to another shape
  def self.can_broadcast?(from_shape : ::Array(Int32), to_shape : ::Array(Int32)) : Bool
    # If the result of broadcast_shapes matches to_shape, then broadcasting is possible
    if result_shape = broadcast_shapes(from_shape, to_shape)
      return result_shape == to_shape
    end

    false
  end

  # Converts a flat index to multi-dimensional indices for a given shape
  private def self.flat_index_to_indices(flat_index : Int32, shape : ::Array(Int32)) : ::Array(Int32)
    ndim = shape.size
    indices = ::Array(Int32).new(ndim, 0)

    remaining = flat_index
    stride = 1

    (ndim - 1).downto(0) do |dim|
      size = shape[dim]
      indices[dim] = (remaining // stride) % size
      stride *= size
    end

    indices
  end

  # Converts multi-dimensional indices to a flat index for a given shape
  private def self.indices_to_flat_index(indices : ::Array(Int32), shape : ::Array(Int32)) : Int32
    flat_index = 0
    stride = 1

    (shape.size - 1).downto(0) do |dim|
      flat_index += indices[dim] * stride
      stride *= shape[dim]
    end

    flat_index
  end

  # Calculates the source indices in the original array for broadcasting
  private def self.broadcast_indices(target_indices : ::Array(Int32), source_shape : ::Array(Int32)) : ::Array(Int32)
    ndim_target = target_indices.size
    ndim_source = source_shape.size

    # The source indices will have the same number of dimensions as the source shape
    source_indices = ::Array(Int32).new(ndim_source, 0)

    # Fill in the source indices, handling broadcasting
    (0...ndim_source).each do |i|
      # Calculate the corresponding dimension in the target
      target_dim = ndim_target - ndim_source + i

      if target_dim >= 0
        # If the source dimension is 1, the index is always 0 (broadcasting)
        # Otherwise, use the target index
        source_indices[i] = source_shape[i] == 1 ? 0 : target_indices[target_dim]
      else
        # This dimension doesn't exist in the target, so use 0
        source_indices[i] = 0
      end
    end

    source_indices
  end

  class Array(T)
    # Broadcasts this array to a new shape
    def broadcast_to(new_shape : ::Array(Int32)) : Array(T)
      Narray.broadcast(self, new_shape)
    end
  end
end
