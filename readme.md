# Basic Metal Boilerplate

This project analyzes how Metal interacts with Swift code, utilizing GPU processing to compute the squares of an array of floats.

## Interaction

1. **Input Setup (Swift)**: The Swift program uploads the input array to the GPU’s memory (input buffer).
2. **Shader Execution (Metal)**: Each thread in the shader calculates the square of the input value and stores the result in the output buffer.
3. **Output Retrieval (Swift)**: After execution, the Swift program reads the GPU’s output buffer to retrieve the squared values.

---

## Swift Breakdown

### 1. Initialize Metal

- Create a Metal device (`MTLDevice`), which represents the GPU.
- Ensure the device supports Metal by checking the result of `MTLCreateSystemDefaultDevice()`.

### 2. Create a Command Queue

- Initialize a command queue (`MTLCommandQueue`) to manage the submission of commands to the GPU.

### 3. Load the Compute Shader

- Load the Metal shader file (`square_values`) into a library (`MTLLibrary`).
- Create a compute pipeline state (`MTLComputePipelineState`) for the shader, which is necessary to execute it on the GPU.

### 4. Input Preparation

- Define an array of floating-point numbers (`inputValues`) as input.
- Calculate the size of the array in bytes to allocate appropriate buffers.

### 5. Create Buffers

- Create two Metal buffers:
  - **Input Buffer**: Stores the input array.
  - **Output Buffer**: Stores the results after processing.

### 6. Create Command Buffer and Encoder

- Create a command buffer (`MTLCommandBuffer`) to record commands.
- Initialize a compute encoder (`MTLComputeCommandEncoder`) to configure and dispatch the GPU compute operation.

### 7. Setup the Compute Encoder

- Configure the compute encoder with:
  - The compute pipeline state (`computePipelineState`).
  - The input and output buffers at indices 0 and 1, respectively.

```swift
computeEncoder.setComputePipelineState(computePipelineState)
computeEncoder.setBuffer(inputBuffer, offset: 0, index: 0)
computeEncoder.setBuffer(outputBuffer, offset: 0, index: 1)
```

### 8. Dispatch Threads

- Define `threadGroupSize`, the number of threads in a threadgroup, based on the GPU's maximum threadgroup size.
- Calculate `threadGroups`, the number of threadgroups needed to process the input array.

### 9. End Encoding and Commit Command Buffer

- End the compute encoding and commit the command buffer to execute on the GPU.
- Wait for the GPU to complete execution.

### 10. Retrieve and Verify Results

- Access the output buffer’s memory to read the computed values.
- Compare the squared results with the expected values (`inputValues.map { $0 * $0 }`) to verify correctness.

### 11. Print Results

---

## Key Concepts

### **MTLCommandBuffer**
- A `commandBuffer` is a container for GPU commands.
- Acts as a playlist of commands.

### **MTLComputeCommandEncoder**
- A `computeCommandEncoder` is used specifically for encoding compute commands.
- Adds compute-specific tasks into the `commandBuffer`.

A `computeCommandEncoder` is created from a `commandBuffer`.

