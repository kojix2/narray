require "../src/narray"
require "stumpy_png"

# Image parameters
WIDTH = 800
HEIGHT = 600
MAX_ITERATIONS = 100
ESCAPE_RADIUS = 2.0

# Complex plane range
X_MIN = -2.5
X_MAX = 1.0
Y_MIN = -1.5
Y_MAX = 1.5

# Calculate Mandelbrot set using NArray
def compute_mandelbrot
  # Array to store results
  result = Narray.zeros([HEIGHT, WIDTH])

  # Generate x and y coordinate grids
  x_range = Narray.linspace(X_MIN, X_MAX, WIDTH)
  y_range = Narray.linspace(Y_MIN, Y_MAX, HEIGHT)

  # Calculate for each pixel
  HEIGHT.times do |y|
    WIDTH.times do |x|
      c_real = x_range[[x]]
      c_imag = y_range[[y]]

      # Mandelbrot calculation
      z_real = 0.0
      z_imag = 0.0
      iteration = 0

      while iteration < MAX_ITERATIONS
        z_real_sq = z_real * z_real
        z_imag_sq = z_imag * z_imag

        # Check for divergence
        if z_real_sq + z_imag_sq > ESCAPE_RADIUS * ESCAPE_RADIUS
          break
        end

        # Calculate next z
        z_imag = 2.0 * z_real * z_imag + c_imag
        z_real = z_real_sq - z_imag_sq + c_real

        iteration += 1
      end

      result[[y, x]] = iteration
    end
  end

  result
end

# Color mapping function
def color_map(iteration)
  if iteration == MAX_ITERATIONS
    # Points in the Mandelbrot set are black
    StumpyPNG::RGBA.from_rgb(0, 0, 0)
  else
    # Diverging points are colored based on iteration count
    # Generate cyclic colors in HSV color space
    hue = (iteration.to_f / MAX_ITERATIONS * 360).to_i % 360

    # Simple HSV -> RGB conversion
    # Convert hue to 0-5 range
    h_i = (hue / 60).to_i
    f = hue / 60.0 - h_i

    v = 255  # Value (brightness)
    s = 1.0  # Saturation

    p = (v * (1 - s)).to_i
    q = (v * (1 - s * f)).to_i
    t = (v * (1 - s * (1 - f))).to_i

    case h_i
    when 0
      StumpyPNG::RGBA.from_rgb(v, t, p)
    when 1
      StumpyPNG::RGBA.from_rgb(q, v, p)
    when 2
      StumpyPNG::RGBA.from_rgb(p, v, t)
    when 3
      StumpyPNG::RGBA.from_rgb(p, q, v)
    when 4
      StumpyPNG::RGBA.from_rgb(t, p, v)
    else
      StumpyPNG::RGBA.from_rgb(v, p, q)
    end
  end
end

puts "Computing Mandelbrot set..."
start_time = Time.monotonic
mandelbrot_data = compute_mandelbrot
end_time = Time.monotonic
puts "Computation completed in #{(end_time - start_time).total_seconds} seconds"

# Generate the image
puts "Generating image..."
canvas = StumpyPNG::Canvas.new(WIDTH, HEIGHT)

# Convert results to image
HEIGHT.times do |y|
  WIDTH.times do |x|
    iteration = mandelbrot_data[[y, x]].to_i
    canvas[x, y] = color_map(iteration)
  end
end

# Save as PNG image
output_file = "mandelbrot_narray.png"
StumpyPNG.write(canvas, output_file)

puts "Mandelbrot set image has been generated as '#{output_file}'"
