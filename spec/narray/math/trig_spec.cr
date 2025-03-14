require "../../spec_helper"

describe Narray::Math do
  describe ".sin" do
    it "computes the sine of each element in the array" do
      a = Narray.array([2, 2], [0.0, Math::PI / 2, Math::PI, 3 * Math::PI / 2])
      b = Narray::Math.sin(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 2], [np.pi, 3 * np.pi / 2]])

      # Apply sine function
      b = np.sin(a)

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

  describe ".sin!" do
    it "computes the sine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, Math::PI / 2, Math::PI, 3 * Math::PI / 2])
      Narray::Math.sin!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 2], [np.pi, 3 * np.pi / 2]])

      # Apply sine function
      b = np.sin(a)

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

  describe ".cos" do
    it "computes the cosine of each element in the array" do
      a = Narray.array([2, 2], [0.0, Math::PI / 2, Math::PI, 3 * Math::PI / 2])
      b = Narray::Math.cos(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 2], [np.pi, 3 * np.pi / 2]])

      # Apply cosine function
      b = np.cos(a)

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

  describe ".cos!" do
    it "computes the cosine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, Math::PI / 2, Math::PI, 3 * Math::PI / 2])
      Narray::Math.cos!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 2], [np.pi, 3 * np.pi / 2]])

      # Apply cosine function
      b = np.cos(a)

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

  describe ".tan" do
    it "computes the tangent of each element in the array" do
      a = Narray.array([2, 2], [0.0, Math::PI / 4, Math::PI / 2, Math::PI])
      b = Narray::Math.tan(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 4], [np.pi / 2, np.pi]])

      # Apply tangent function
      b = np.tan(a)

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

  describe ".tan!" do
    it "computes the tangent of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, Math::PI / 4, Math::PI / 2, Math::PI])
      Narray::Math.tan!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, np.pi / 4], [np.pi / 2, np.pi]])

      # Apply tangent function
      b = np.tan(a)

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

  describe ".asin" do
    it "computes the arcsine of each element in the array" do
      a = Narray.array([2, 2], [0.0, 0.5, 1.0, -0.5])
      b = Narray::Math.asin(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 0.5], [1.0, -0.5]])

      # Apply arcsine function
      b = np.arcsin(a)

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

  describe ".asin!" do
    it "computes the arcsine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 0.5, 1.0, -0.5])
      Narray::Math.asin!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 0.5], [1.0, -0.5]])

      # Apply arcsine function
      b = np.arcsin(a)

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

  describe ".acos" do
    it "computes the arccosine of each element in the array" do
      a = Narray.array([2, 2], [0.0, 0.5, 1.0, -0.5])
      b = Narray::Math.acos(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 0.5], [1.0, -0.5]])

      # Apply arccosine function
      b = np.arccos(a)

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

  describe ".acos!" do
    it "computes the arccosine of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 0.5, 1.0, -0.5])
      Narray::Math.acos!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 0.5], [1.0, -0.5]])

      # Apply arccosine function
      b = np.arccos(a)

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

  describe ".atan" do
    it "computes the arctangent of each element in the array" do
      a = Narray.array([2, 2], [0.0, 1.0, -1.0, 0.5])
      b = Narray::Math.atan(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [-1.0, 0.5]])

      # Apply arctangent function
      b = np.arctan(a)

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

  describe ".atan!" do
    it "computes the arctangent of each element in the array in-place" do
      a = Narray.array([2, 2], [0.0, 1.0, -1.0, 0.5])
      Narray::Math.atan!(a)

      # Run NumPy code to get the expected results
      numpy_code = <<-PYTHON
      import numpy as np

      # Create the same 2x2 array
      a = np.array([[0.0, 1.0], [-1.0, 0.5]])

      # Apply arctangent function
      b = np.arctan(a)

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
