# NArray

[![build](https://github.com/kojix2/narray/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/narray/actions/workflows/test.yml)

A multi-dimensional numerical array library for Crystal language. Inspired by NumPy and Numo::NArray, it can be used for scientific computing, data analysis, machine learning, and more.

## Features

- Support for multi-dimensional arrays (N-dimensional arrays)
- Various array creation functions (zeros, ones, arange, linspace, etc.)
- Array manipulation functions (reshape, transpose, concatenate, etc.)
- Mathematical operations (basic arithmetic operations, element-wise functions)
- Broadcasting support for operations between arrays of different shapes
- Linear algebra functions (matrix multiplication, determinant, inverse, eigenvalues, SVD)
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
puts arr.at([0, 0])                     # 1
puts arr.at(0, 0)                       # 1 (variadic indices)
puts arr[[0, 0]]                        # 1 (bracket notation)
puts arr[[1, 2]]                        # 6

# Slicing arrays
sub_arr = arr.slice([0..1, 1..2])       # Slice with range indices
row = arr.slice([0, true])              # Select entire row (true selects all elements)
col = arr.slice([true, 1])              # Select entire column
last_row = arr.slice([-1, true])        # Select last row (negative indices count from the end)
sub_matrix = arr.slice([-2..-1, 0..1])  # Select last two rows and first two columns

# Setting slices
new_data = Narray.array([2, 2], [100, 200, 300, 400])
arr.slice_set([0..1, 0..1], new_data)   # Replace top-left 2x2 submatrix
arr[[0..1, 0..1]] = new_data            # Same operation using bracket notation
row_data = Narray.array([1, 4], [100, 200, 300, 400])
arr.slice_set([0, true], row_data)      # Replace entire first row
col_data = Narray.array([3, 1], [500, 600, 700])
arr.slice_set([true, 1], col_data)      # Replace entire second column
arr.slice_set([-1, true], row_data)     # Replace last row (negative index)
single_element = Narray.array([1, 1], [999])
arr.slice_set([-2, -3], single_element) # Replace element at second-to-last row, third-to-last column

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

# Element-wise operations (in-place)
a.add!(b)                               # Element-wise addition (in-place)
a.subtract!(b)                          # Element-wise subtraction (in-place)
a.multiply!(b)                          # Element-wise multiplication (in-place)
a.divide!(b)                            # Element-wise division (in-place)

# Scalar operations
scaled = a * 2                          # Multiply each element by 2
offset = a + 5                          # Add 5 to each element

# Scalar operations (in-place)
a.add!(5)                               # Add 5 to each element (in-place)
a.multiply!(2)                          # Multiply each element by 2 (in-place)

# Broadcasting operations
row = Narray.array([1, 3], [1, 2, 3])   # 1D array with shape [3]
column = Narray.array([3, 1], [1, 2, 3]) # 2D array with shape [3, 1]
result = row + column                   # Broadcasting: result has shape [3, 3]

# You can also broadcast in-place operations
a = Narray.array([2, 2], [1, 2, 3, 4])
b = Narray.array([1, 2], [10, 20])      # 1D array with shape [2]
a.add!(b)                               # Broadcasting: a becomes [[11, 22], [13, 24]]

# Matrix operations
dot_product = Narray.dot(a, b)          # Matrix multiplication
det = Narray.det(a)                     # Matrix determinant
inv = Narray.inv(a)                     # Matrix inverse
eigenvalues, eigenvectors = Narray.eig(a) # Eigenvalues and eigenvectors
u, s, vt = Narray.svd(a)                # Singular Value Decomposition

# Statistical operations
puts a.sum                              # Sum of all elements
puts a.mean                             # Mean value
puts a.min                              # Minimum value
puts a.max                              # Maximum value
puts a.std                              # Standard deviation
```

## Current Implementation Status

- ✅ Basic multi-dimensional array class
- ✅ Array access and slicing (element access, range slicing, dimension selection)
- ✅ Array manipulation functions (reshape, transpose, concatenate)
- ✅ Mathematical operations (arithmetic, statistics)
- ✅ Broadcasting support for operations between arrays of different shapes
- ✅ Basic linear algebra (dot product)
- ✅ Advanced linear algebra (determinant, inverse, eigenvalues, SVD)
- 🔄 Advanced features (in progress)

## Future Development

This library is being developed incrementally:

1. ✅ Implementation of basic multi-dimensional array class
2. ✅ Implementation of array access and slicing
   - ✅ Element access with indices
   - ✅ Range-based slicing
   - ✅ Negative indices (counting from the end)
   - ✅ Dimension selection with boolean flags
3. ✅ Implementation of array manipulation functions
4. ✅ Implementation of mathematical operations
5. ✅ Implementation of advanced linear algebra functions
   - ✅ Inverse matrices, determinants
   - ✅ Eigenvalues, eigenvectors
   - ✅ Matrix decompositions (SVD)
6. 🔄 Implementation of advanced features
   - Fourier transforms
   - Random number generation
   - Interpolation, extrapolation

## Verification

The test suite includes automatic verification against NumPy for linear algebra functions. The tests run Python code directly from Crystal to compare results with NumPy, ensuring numerical accuracy and consistency.

This approach allows for continuous verification of:
- Determinant calculation
- Matrix inversion
- Eigenvalue decomposition
- Singular Value Decomposition (SVD)

## Contributing

1. Fork it (<https://github.com/kojix2/narray/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Consider adding verification scripts for new functionality

## Contributors

- [kojix2](https://github.com/kojix2) - creator and maintainer
