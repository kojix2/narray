require "../../spec_helper"

describe Narray::Math do
  describe ".sinh" do
    it "computes the hyperbolic sine of each element in the array" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      b = Narray::Math.sinh(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic sine function
      b = np.sinh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      b.shape.should eq([2, 2])
      b.data[0].should be_close(numpy_values[0], 1e-10)
      b.data[1].should be_close(numpy_values[1], 1e-10)
      b.data[2].should be_close(numpy_values[2], 1e-10)
      b.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end

  describe ".sinh!" do
    it "computes the hyperbolic sine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      Narray::Math.sinh!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic sine function
      b = np.sinh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      a.shape.should eq([2, 2])
      a.data[0].should be_close(numpy_values[0], 1e-10)
      a.data[1].should be_close(numpy_values[1], 1e-10)
      a.data[2].should be_close(numpy_values[2], 1e-10)
      a.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end

  describe ".cosh" do
    it "computes the hyperbolic cosine of each element in the array" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      b = Narray::Math.cosh(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic cosine function
      b = np.cosh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      b.shape.should eq([2, 2])
      b.data[0].should be_close(numpy_values[0], 1e-10)
      b.data[1].should be_close(numpy_values[1], 1e-10)
      b.data[2].should be_close(numpy_values[2], 1e-10)
      b.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end

  describe ".cosh!" do
    it "computes the hyperbolic cosine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      Narray::Math.cosh!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic cosine function
      b = np.cosh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      a.shape.should eq([2, 2])
      a.data[0].should be_close(numpy_values[0], 1e-10)
      a.data[1].should be_close(numpy_values[1], 1e-10)
      a.data[2].should be_close(numpy_values[2], 1e-10)
      a.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end

  describe ".tanh" do
    it "computes the hyperbolic tangent of each element in the array" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      b = Narray::Math.tanh(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic tangent function
      b = np.tanh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      b.shape.should eq([2, 2])
      b.data[0].should be_close(numpy_values[0], 1e-10)
      b.data[1].should be_close(numpy_values[1], 1e-10)
      b.data[2].should be_close(numpy_values[2], 1e-10)
      b.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end

  describe ".tanh!" do
    it "computes the hyperbolic tangent of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      Narray::Math.tanh!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply hyperbolic tangent function
      b = np.tanh(a)

      # Print the results
      print(f"{b[0,0]:.10f} {b[0,1]:.10f} {b[1,0]:.10f} {b[1,1]:.10f}")
      PYTHON

      # Run the NumPy code and parse the results
      numpy_result = PythonHelper.run_python_code(numpy_code).strip
      numpy_values = numpy_result.split.map { |val| val.to_f }

      # Compare with NumPy results
      a.shape.should eq([2, 2])
      a.data[0].should be_close(numpy_values[0], 1e-10)
      a.data[1].should be_close(numpy_values[1], 1e-10)
      a.data[2].should be_close(numpy_values[2], 1e-10)
      a.data[3].should be_close(numpy_values[3], 1e-10)
    end
  end
end
