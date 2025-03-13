# NArray

A multi-dimensional numerical array library for Crystal language. Inspired by NumPy and Numo::NArray, it can be used for scientific computing, data analysis, machine learning, and more.

## Features

- Support for multi-dimensional arrays (N-dimensional arrays)
- Various array creation functions (zeros, ones, arange, linspace, etc.)
- Array manipulation functions (reshape, transpose, concatenate, etc.)
- Mathematical operations (basic arithmetic operations, element-wise functions)
- Linear algebra functions (matrix multiplication)
- Statistical functions (mean, variance, standard deviation, etc.)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     narray:
       github: kojix2/narray
   ```

2. Run `shards install`

## Usage

### Creating Arrays

```crystal
require "narray"

# Create arrays with different methods
zeros = Narray.zeros([2, 3])           # 2x3 array filled with zeros
ones = Narray.ones([2, 3])             # 2x3 array filled with ones
range = Narray.arange(0, 10, 2)        # [0, 2, 4, 6, 8]
linear = Narray.linspace(0, 1, 5)      # [0.0, 0.25, 0.5, 0.75, 1.0]

# Create array from existing data
data = [1, 2, 3, 4, 5, 6]
arr = Narray.array([2, 3], data)       # 2x3 array with the given data
```

### Array Operations

```crystal
# Basic array information
arr = Narray.array([2, 3], [1, 2, 3, 4, 5, 6])
puts arr.shape                          # [2, 3]
puts arr.ndim                           # 2
puts arr.size                           # 6

# Accessing elements
puts arr[[0, 0]]                        # 1
puts arr[[1, 2]]                        # 6

# Reshaping arrays
reshaped = arr.reshape([3, 2])          # 3x2 array with the same data
transposed = arr.transpose              # 3x2 array, transposed

# Combining arrays
a = Narray.array([2, 2], [1, 2, 3, 4])
b = Narray.array([2, 2], [5, 6, 7, 8])
vertical = Narray.vstack([a, b])        # Stack arrays vertically
horizontal = Narray.hstack([a, b])      # Stack arrays horizontally
combined = Narray.concatenate([a, b], 0) # Concatenate along first axis
```

### Mathematical Operations

```crystal
a = Narray.array([2, 2], [1, 2, 3, 4])
b = Narray.array([2, 2], [5, 6, 7, 8])

# Element-wise operations
sum = a + b                             # Element-wise addition
diff = a - b                            # Element-wise subtraction
product = a * b                         # Element-wise multiplication
quotient = a / b                        # Element-wise division

# Scalar operations
scaled = a * 2                          # Multiply each element by 2
offset = a + 5                          # Add 5 to each element

# Matrix operations
dot_product = Narray.dot(a, b)          # Matrix multiplication

# Statistical operations
puts a.sum                              # Sum of all elements
puts a.mean                             # Mean value
puts a.min                              # Minimum value
puts a.max                              # Maximum value
puts a.std                              # Standard deviation
```

## Current Implementation Status

- ✅ Basic multi-dimensional array class
- ✅ Array manipulation functions (reshape, transpose, concatenate)
- ✅ Mathematical operations (arithmetic, statistics)
- ✅ Basic linear algebra (dot product)
- 🔄 Advanced linear algebra (in progress)
- 🔄 Advanced features (in progress)

## Future Development

This library is being developed incrementally:

1. ✅ Implementation of basic multi-dimensional array class
2. ✅ Implementation of array manipulation functions
3. ✅ Implementation of mathematical operations
4. 🔄 Implementation of advanced linear algebra functions
   - Inverse matrices, determinants
   - Eigenvalues, eigenvectors
   - Matrix decompositions
5. 🔄 Implementation of advanced features
   - Fourier transforms
   - Random number generation
   - Interpolation, extrapolation

## Contributing

1. Fork it (<https://github.com/kojix2/narray/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kojix2](https://github.com/kojix2) - creator and maintainer
