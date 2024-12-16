//
//  main.swift
//  SimpleShader
//
//  Created by Sebastian Juarez on 12/16/24.
//

import Metal
import Foundation

// Initialize Metal
guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("Metal is not supported on this device.")
}

guard let commandQueue = device.makeCommandQueue() else {
    fatalError("Failed to create Metal command queue.")
}

// load the computer shader
guard let library = try? device.makeDefaultLibrary(),
      let kernelFunction = library.makeFunction(name: "square_values") else {
    fatalError("Failed to load the Metal compute shader.")
}

guard let computePipelineState = try? device.makeComputePipelineState(function: kernelFunction) else {
    fatalError("Failed to create compute pipeline state.")
}

let inputValues : [Float] = [1.0, 2.0, 3.0, 4.0, 5.0]
let inputSize = inputValues.count * MemoryLayout<Float>.size

// Create Metal buffers
guard let inputBuffer = device.makeBuffer(bytes: inputValues,
                                          length: inputSize,
                                          options: .storageModeShared),
      let outputBuffer = device.makeBuffer(length: inputSize,
                                           options: .storageModeShared) else {
    fatalError("Failed to create Metal buffers.")
}

// Create a command buffer and encoder
guard let commandBuffer = commandQueue.makeCommandBuffer(),
      let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
    fatalError("Failed to create command buffer or compute encoder.")
}

// Configure the compute encoder
computeEncoder.setComputePipelineState(computePipelineState)
computeEncoder.setBuffer(inputBuffer, offset: 0, index: 0)
computeEncoder.setBuffer(outputBuffer, offset: 0, index: 1)
        
        
// Dispatch threads
let threadGroupSize = MTLSize(width: computePipelineState.maxTotalThreadsPerThreadgroup, height: 1, depth: 1)
let threadGroups = MTLSize(width: (inputValues.count + threadGroupSize.width - 1) / threadGroupSize.width,
                           height: 1,
                           depth: 1)

computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
computeEncoder.endEncoding()

// Commit the command buffer
commandBuffer.commit()
commandBuffer.waitUntilCompleted()

// Retrieve results
let outputPointer = outputBuffer.contents().bindMemory(to: Float.self, capacity: inputValues.count)
let outputValues = Array(UnsafeBufferPointer(start: outputPointer, count: inputValues.count))

// Print results
for (index, value) in outputValues.enumerated() {
    print("Input: \(inputValues[index]), Squared: \(value)")
}

// Verify correctness
let expectedValues = inputValues.map { $0 * $0 }
assert(outputValues == expectedValues, "The output values do not match the expected results.")
print("All values squared correctly!")
