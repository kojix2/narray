require "../src/narray"

# Create a sample array
arr = Narray.array([10], (1..10).to_a)
puts "Original array:"
puts arr.inspect

# Create a mask using comparison operators
mask = arr.gt(5)
puts "\nMask (arr > 5):"
puts mask.inspect

# Same using operator syntax
mask2 = arr > 5
puts "\nMask using operator syntax (arr > 5):"
puts mask2.inspect

# Use the mask to select elements
result = arr.mask(mask)
puts "\nElements where arr > 5:"
puts result.inspect

# Use a block to create a mask
result2 = arr.mask { |x| x.even? }
puts "\nEven elements:"
puts result2.inspect

# Update elements using a mask
arr2 = arr.dup
arr2.mask_set(mask, 0)
puts "\nArray with elements > 5 set to 0:"
puts arr2.inspect

# Update elements using a block
arr3 = arr.dup
arr3.mask_set(100) { |x| x < 3 }
puts "\nArray with elements < 3 set to 100:"
puts arr3.inspect

# Create two arrays
a = Narray.array([5], [1, 2, 3, 4, 5])
b = Narray.array([5], [5, 4, 3, 2, 1])

# Compare arrays
eq_mask = a.eq(b)
puts "\nElements where a equals b:"
puts eq_mask.inspect

# Same using operator syntax
eq_mask2 = a == b
puts "\nElements where a equals b (using operator syntax):"
puts eq_mask2.inspect

# Use the mask to select elements
common_elements = a.mask(eq_mask)
puts "\nCommon elements between a and b:"
puts common_elements.inspect

# Demonstrate broadcasting with comparison
c = Narray.array([2, 1], [1, 2])
d = Narray.array([1, 3], [0, 1, 2])
broadcast_mask = c.gt(d)
puts "\nBroadcasting comparison (c > d):"
puts broadcast_mask.inspect

# Demonstrate other comparison operators
puts "\nDemonstrating other comparison operators:"
puts "a < b: #{(a < b).inspect}"
puts "a <= b: #{(a <= b).inspect}"
puts "a >= b: #{(a >= b).inspect}"
puts "a != b: #{(a != b).inspect}"
