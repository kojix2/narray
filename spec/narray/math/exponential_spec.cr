require "../../spec_helper"

describe Narray::Math do
  describe ".exp" do
    it "computes the exponential of each element in the array" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      b = Narray::Math.exp(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply exponential function
      b = np.exp(a)

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

  describe ".exp!" do
    it "computes the exponential of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 1.0, 2.0, 3.0])
      Narray::Math.exp!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [2.0, 3.0]])

      # Apply exponential function
      b = np.exp(a)

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

  describe ".log" do
    it "computes the natural logarithm of each element in the array" do
      a = Narray.array([2, 2], [1.0, Math::E, Math::E**2, Math::E**3])
      b = Narray::Math.log(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, np.e], [np.e**2, np.e**3]])

      # Apply logarithm function
      b = np.log(a)

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

  describe ".log!" do
    it "computes the natural logarithm of each element in the array in-place" do
      a = Narray.array([2, 2], [1.0, Math::E, Math::E**2, Math::E**3])
      Narray::Math.log!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, np.e], [np.e**2, np.e**3]])

      # Apply logarithm function
      b = np.log(a)

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

  describe ".log10" do
    it "computes the base-10 logarithm of each element in the array" do
      a = Narray.array([2, 2], [1.0, 10.0, 100.0, 1000.0])
      b = Narray::Math.log10(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 10.0], [100.0, 1000.0]])

      # Apply base-10 logarithm function
      b = np.log10(a)

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

  describe ".log10!" do
    it "computes the base-10 logarithm of each element in the array in-place" do
      a = Narray.array([2, 2], [1.0, 10.0, 100.0, 1000.0])
      Narray::Math.log10!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 10.0], [100.0, 1000.0]])

      # Apply base-10 logarithm function
      b = np.log10(a)

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

  describe ".sqrt" do
    it "computes the square root of each element in the array" do
      a = Narray.array([2, 2], [1.0, 4.0, 9.0, 16.0])
      b = Narray::Math.sqrt(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 4.0], [9.0, 16.0]])

      # Apply square root function
      b = np.sqrt(a)

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

  describe ".sqrt!" do
    it "computes the square root of each element in the array in-place" do
      a = Narray.array([2, 2], [1.0, 4.0, 9.0, 16.0])
      Narray::Math.sqrt!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 4.0], [9.0, 16.0]])

      # Apply square root function
      b = np.sqrt(a)

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

  describe ".pow" do
    it "raises each element in the array to the given power" do
      a = Narray.array([2, 2], [1.0, 2.0, 3.0, 4.0])
      b = Narray::Math.pow(a, 2)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 2.0], [3.0, 4.0]])

      # Apply power function
      b = np.power(a, 2)

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

  describe ".pow!" do
    it "raises each element in the array to the given power in-place" do
      a = Narray.array([2, 2], [1.0, 2.0, 3.0, 4.0])
      Narray::Math.pow!(a, 2)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[1.0, 2.0], [3.0, 4.0]])

      # Apply power function
      b = np.power(a, 2)

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
