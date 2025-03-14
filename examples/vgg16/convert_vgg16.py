#!/usr/bin/env python3
"""
Convert VGG16 model from npz format to a binary format readable by Crystal.
This script downloads the VGG16 model from TensorPack and converts it to a binary format.
"""

import numpy as np
import struct
import os
import sys
import urllib.request
import json

def download_model(url, path):
    """Download the model from the given URL to the specified path."""
    print(f"Downloading VGG16 model from {url}...")
    
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(path), exist_ok=True)
    
    # Download the model
    urllib.request.urlretrieve(url, path)
    
    print(f"Model downloaded to {path}")

def convert_model(npz_path, bin_path, json_path):
    """Convert the npz model to a binary format readable by Crystal."""
    print(f"Converting model from {npz_path} to {bin_path}...")
    
    # Load the npz file
    data = np.load(npz_path)
    
    # Create metadata
    metadata = {}
    
    # Open binary file for writing
    with open(bin_path, 'wb') as f:
        # Write number of parameters
        num_params = len(data.files)
        f.write(struct.pack('i', num_params))
        
        # Process each parameter
        for name in data.files:
            param = data[name]
            
            # Store metadata
            layer_name = name.split('/')[0]
            param_type = "weights" if name.endswith("/W") or name.endswith("/weights") else "biases"
            
            if layer_name not in metadata:
                metadata[layer_name] = {}
            
            metadata[layer_name][param_type] = {
                "shape": param.shape,
                "offset": f.tell(),  # Current position in the file
                "size": param.size
            }
            
            # Write parameter name length
            name_bytes = name.encode('utf-8')
            f.write(struct.pack('i', len(name_bytes)))
            
            # Write parameter name
            f.write(name_bytes)
            
            # Write parameter shape
            f.write(struct.pack('i', len(param.shape)))
            for dim in param.shape:
                f.write(struct.pack('i', dim))
            
            # Write parameter data
            param_flat = param.flatten().astype(np.float32)
            f.write(struct.pack(f'{len(param_flat)}f', *param_flat))
    
    # Save metadata to JSON file
    with open(json_path, 'w') as f:
        json.dump(metadata, f, indent=2)
    
    print(f"Model converted to {bin_path}")
    print(f"Metadata saved to {json_path}")

def main():
    """Main function."""
    # Define paths
    url = "http://models.tensorpack.com/Caffe-Converted/vgg16.npz"
    script_dir = os.path.dirname(os.path.abspath(__file__))
    npz_path = os.path.join(script_dir, "models/vgg16.npz")
    bin_path = os.path.join(script_dir, "models/vgg16.bin")
    json_path = os.path.join(script_dir, "models/vgg16_metadata.json")
    
    # Download the model if it doesn't exist
    if not os.path.exists(npz_path):
        download_model(url, npz_path)
    
    # Convert the model
    convert_model(npz_path, bin_path, json_path)
    
    print("Conversion completed successfully!")

if __name__ == "__main__":
    main()
