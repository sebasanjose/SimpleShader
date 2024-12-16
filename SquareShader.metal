//
//  SquareShader.metal
//  SimpleShader
//
//  Created by Sebastian Juarez on 12/16/24.
//

#include <metal_stdlib>
using namespace metal;

kernel void square_values(const device float* input [[buffer(0)]],
                          device float* output [[buffer(1)]],
                          uint id [[thread_position_in_grid]]) {
    output[id] = input[id] * input[id];
}
