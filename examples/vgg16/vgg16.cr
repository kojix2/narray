require "../../src/narray"
require "stumpy_png"
require "option_parser"

# Lightweight implementation of VGG16 model for image classification
# Inspired by the Ruby implementation concept

# Extend Narray::Array with methods for CNN operations
class Narray::Array(T)
  # Convolution operation
  def conv(weight : Narray::Array(T), bias : Narray::Array(T)) : Narray::Array(T)
    c, h, w = shape
    # Zero padding
    padded = Narray.zeros([c, h+2, w+2], T)

    # Copy data to padded array
    c.times do |ch|
      (h+2).times do |y|
        next if y == 0 || y == h+1
        (w+2).times do |x|
          next if x == 0 || x == w+1
          padded.data[(ch * (h+2) * (w+2)) + (y * (w+2)) + x] = self.data[(ch * h * w) + ((y-1) * w) + (x-1)]
        end
      end
    end

    out_channels = weight.shape[0]
    result = Narray.zeros([out_channels, h, w], T)

    # Perform convolution
    out_channels.times do |oc|
      h.times do |y|
        w.times do |x|
          sum = T.new(0)

          # Convolve over 3x3 filter
          c.times do |ch|
            3.times do |ky|
              3.times do |kx|
                py = y + ky
                px = x + kx
                sum += padded.data[(ch * (h+2) * (w+2)) + (py * (w+2)) + px] *
                       weight.data[(oc * c * 3 * 3) + (ch * 3 * 3) + (ky * 3) + kx]
              end
            end
          end

          # Add bias
          result.data[(oc * h * w) + (y * w) + x] = sum + bias.data[oc]
        end
      end
    end

    result
  end

  # ReLU activation function
  def relu : Narray::Array(T)
    result = Narray.zeros(shape, T)
    self.size.times do |i|
      result.data[i] = self.data[i] < 0 ? T.new(0) : self.data[i]
    end
    result
  end

  # Max pooling operation (2x2)
  def pool : Narray::Array(T)
    c, h, w = shape
    result = Narray.zeros([c, h//2, w//2], T)

    # Perform max pooling
    c.times do |ch|
      (h//2).times do |y|
        (w//2).times do |x|
          # Find maximum in 2x2 region
          max_val = T.new(-Float32::MAX)
          2.times do |ky|
            2.times do |kx|
              py = y * 2 + ky
              px = x * 2 + kx
              val = self.data[(ch * h * w) + (py * w) + px]
              max_val = val if val > max_val
            end
          end
          result.data[(ch * (h//2) * (w//2)) + (y * (w//2)) + x] = max_val
        end
      end
    end

    result
  end

  # Flatten operation (for transition from conv to fully connected)
  def flatten : Narray::Array(T)
    Narray.array([1, self.size], self.data)
  end

  # Fully connected layer operation
  def line(weight : Narray::Array(T), bias : Narray::Array(T)) : Narray::Array(T)
    batch_size, input_size = shape
    output_size = bias.size
    result = Narray.zeros([batch_size, output_size], T)

    # Perform matrix multiplication and add bias
    batch_size.times do |b|
      output_size.times do |o|
        sum = bias.data[o]
        input_size.times do |i|
          sum += self.data[(b * input_size) + i] * weight.data[(i * output_size) + o]
        end
        result.data[(b * output_size) + o] = sum
      end
    end

    result
  end

  # Softmax function
  def softmax : Narray::Array(T)
    batch_size, num_classes = shape
    result = Narray.zeros([batch_size, num_classes], T)

    # Apply softmax to each batch
    batch_size.times do |b|
      # Find max value for numerical stability
      max_val = T.new(-Float32::MAX)
      num_classes.times do |i|
        val = self.data[(b * num_classes) + i]
        max_val = val if val > max_val
      end

      # Calculate sum of exponentials
      sum_exp = T.new(0)
      num_classes.times do |i|
        exp_val = ::Math.exp((self.data[(b * num_classes) + i] - max_val).to_f64).to_f32
        sum_exp += exp_val
      end

      # Calculate softmax values
      num_classes.times do |i|
        exp_val = ::Math.exp((self.data[(b * num_classes) + i] - max_val).to_f64).to_f32
        result.data[(b * num_classes) + i] = exp_val / sum_exp
      end
    end

    result
  end
end

# Helper function to create dummy weights for testing
def load_weight(filename : String, shape : Array(Int32)) : Narray::Array(Float32)
  # For testing purposes, create dummy weights
  # In production, these would be loaded from binary files
  puts "Creating dummy weights for #{filename} with shape #{shape}"

  # Create a dummy array filled with small random values
  size = shape.product
  data = Array(Float32).new(size) { (rand * 0.01).to_f32 }

  # For bias vectors, use small constant values
  if shape.size == 1
    data = Array(Float32).new(size) { 0.01_f32 }
  end

  Narray.array(shape, data)
end

# Main process
image_path = ""

# Parse command line options
OptionParser.parse do |parser|
  parser.banner = "Usage: crystal examples/vgg16/vgg16_light.cr [options] <image_path>"

  parser.on("-h", "--help", "Show this help message") do
    puts parser
    exit 0
  end

  parser.invalid_option do |flag|
    STDERR.puts "Error: Unknown option: #{flag}"
    STDERR.puts parser
    exit 1
  end
end

# Check if image path is provided
if ARGV.size < 1
  STDERR.puts "Error: No image path provided"
  STDERR.puts "Usage: crystal examples/vgg16/vgg16_light.cr [options] <image_path>"
  exit 1
end

image_path = ARGV[0]

# Check if image file exists
unless File.exists?(image_path)
  STDERR.puts "Error: Image file not found: #{image_path}"
  exit 1
end

# Load weights and biases
puts "Loading model parameters..."

# Load weights
W01 = load_weight("W01", [64, 3, 3, 3])
W02 = load_weight("W02", [64, 64, 3, 3])
W03 = load_weight("W03", [128, 64, 3, 3])
W04 = load_weight("W04", [128, 128, 3, 3])
W05 = load_weight("W05", [256, 128, 3, 3])
W06 = load_weight("W06", [256, 256, 3, 3])
W07 = load_weight("W07", [256, 256, 3, 3])
W08 = load_weight("W08", [512, 256, 3, 3])
W09 = load_weight("W09", [512, 512, 3, 3])
W10 = load_weight("W10", [512, 512, 3, 3])
W11 = load_weight("W11", [512, 512, 3, 3])
W12 = load_weight("W12", [512, 512, 3, 3])
W13 = load_weight("W13", [512, 512, 3, 3])
W14 = load_weight("W14", [4096, 25088])
W15 = load_weight("W15", [4096, 4096])
W16 = load_weight("W16", [1000, 4096])

# Load biases
B01 = load_weight("B01", [64])
B02 = load_weight("B02", [64])
B03 = load_weight("B03", [128])
B04 = load_weight("B04", [128])
B05 = load_weight("B05", [256])
B06 = load_weight("B06", [256])
B07 = load_weight("B07", [256])
B08 = load_weight("B08", [512])
B09 = load_weight("B09", [512])
B10 = load_weight("B10", [512])
B11 = load_weight("B11", [512])
B12 = load_weight("B12", [512])
B13 = load_weight("B13", [512])
B14 = load_weight("B14", [4096])
B15 = load_weight("B15", [4096])
B16 = load_weight("B16", [1000])

# Load class labels
labels = File.read_lines(__DIR__ + "/models/imagenet_classes.txt")

# Load and preprocess image
puts "Loading and preprocessing image..."

# Load image
canvas = StumpyPNG.read(image_path)
height = canvas.height
width = canvas.width

# Check image dimensions
if height != 224 || width != 224
  puts "Warning: Image dimensions should be 224x224 for best results"
  # Simple resize could be implemented here
end

# Convert image to Narray
image_data = Array(Float32).new(3 * height * width, 0_f32)
height.times do |y|
  width.times do |x|
    pixel = canvas[x, y]
    r, g, b = pixel.to_rgb8

    # Store in BGR order (VGG16 uses BGR format)
    image_data[(0 * height * width) + (y * width) + x] = b.to_f32
    image_data[(1 * height * width) + (y * width) + x] = g.to_f32
    image_data[(2 * height * width) + (y * width) + x] = r.to_f32
  end
end

# Create Narray and reshape to [channels, height, width]
image = Narray.array([3, height, width], image_data)

# Subtract mean values
mean = Narray.array([3], [103.939_f32, 116.779_f32, 123.68_f32])
3.times do |c|
  # Subtract mean value for each channel
  height.times do |y|
    width.times do |x|
      image.data[(c * height * width) + (y * width) + x] -= mean.data[c]
    end
  end
end

# Run VGG16 inference with method chaining
puts "Running inference..."

result = image
  .conv(W01, B01).relu
  .conv(W02, B02).relu
  .pool.tap { puts "Block 1 completed" }
  .conv(W03, B03).relu
  .conv(W04, B04).relu
  .pool.tap { puts "Block 2 completed" }
  .conv(W05, B05).relu
  .conv(W06, B06).relu
  .conv(W07, B07).relu
  .pool.tap { puts "Block 3 completed" }
  .conv(W08, B08).relu
  .conv(W09, B09).relu
  .conv(W10, B10).relu
  .pool.tap { puts "Block 4 completed" }
  .conv(W11, B11).relu
  .conv(W12, B12).relu
  .conv(W13, B13).relu
  .pool.tap { puts "Block 5 completed" }
  .tap{|x| p x}
  .flatten
  .tap{|y| p y}
  .line(W14, B14).relu
  .line(W15, B15).relu
  .line(W16, B16).softmax

# Get top 5 predictions
predictions = labels.zip(result.data).sort_by { |_, prob| -prob }[0...5]

# Display results
puts "\nTop 5 predictions:"
predictions.each_with_index do |(label, prob), i|
  puts "#{i + 1}. #{label}: #{(prob * 100).round(2)}%"
end
