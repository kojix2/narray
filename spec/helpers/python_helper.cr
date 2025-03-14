require "file_utils"
require "process"

module PythonHelper
  # Run Python code and return the output
  def self.run_python_code(code : String, timeout : Int32 = 10) : String
    # Create a temporary file for the Python code
    temp_file = File.tempfile("numpy_verification", ".py")
    begin
      # Write the Python code to the temporary file
      File.write(temp_file.path, code)

      # Run the Python code and capture the output
      output = IO::Memory.new
      error = IO::Memory.new
      status = Process.run("python", [temp_file.path], output: output, error: error)

      if status.success?
        return output.to_s
      else
        raise "Python execution failed: #{error.to_s}"
      end
    rescue ex : Exception
      raise "Failed to run Python code: #{ex.message}"
    ensure
      # Clean up the temporary file
      temp_file.delete
    end
  end

  # Compare Narray results with NumPy results
  def self.compare_with_numpy(crystal_array : Narray::Array, numpy_code : String) : Array(Float64)
    # Run the NumPy code and parse the results
    numpy_result = run_python_code(numpy_code).strip
    numpy_values = numpy_result.split.map { |val| val.to_f }

    return numpy_values
  end
end
