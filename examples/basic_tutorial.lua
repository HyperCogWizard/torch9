#!/usr/bin/env lua

-- Basic P9ML Tutorial
-- This tutorial demonstrates the fundamental concepts of P9ML membrane computing

print("=== P9ML Basic Tutorial ===\n")

-- Step 1: Initialize the P9ML system
local P9ML = require('P9ML')
print("1. Initializing P9ML system...")
P9ML.init({
    similarity_threshold = 0.3,
    default_quantization = 0.9
})

-- Step 2: Create basic membrane-wrapped neural modules
print("\n2. Creating membrane-wrapped modules...")

local input_layer = P9ML.Linear(4, 8, {
    initial_quantization = 0.9,
    adaptation_rate = 0.02,
    gradient_decay = 0.98
})

local hidden_layer = P9ML.Linear(8, 6, {
    initial_quantization = 0.8,
    adaptation_rate = 0.015
})

local output_layer = P9ML.Linear(6, 2, {
    initial_quantization = 0.85,
    adaptation_rate = 0.01
})

print("✓ Created input layer:", input_layer:getId():sub(1,8) .. "...")
print("✓ Created hidden layer:", hidden_layer:getId():sub(1,8) .. "...")
print("✓ Created output layer:", output_layer:getId():sub(1,8) .. "...")

-- Step 3: Connect membranes to form a computation graph
print("\n3. Connecting membranes...")
input_layer:connectTo(hidden_layer)
hidden_layer:connectTo(output_layer)
print("✓ Connected: input → hidden → output")

-- Step 4: Create mock tensor for demonstration
local function MockTensor(data, size)
    local tensor = {
        _data = data,
        _size = size,
        _norm = nil
    }
    
    function tensor:size()
        return {
            totable = function() return tensor._size end
        }
    end
    
    function tensor:norm()
        if not tensor._norm then
            local sum = 0
            for _, v in ipairs(tensor._data) do
                sum = sum + v * v
            end
            tensor._norm = math.sqrt(sum)
        end
        return tensor._norm
    end
    
    function tensor:clone()
        local new_data = {}
        for i, v in ipairs(tensor._data) do
            new_data[i] = v
        end
        return MockTensor(new_data, tensor._size)
    end
    
    return tensor
end

-- Set up mock torch for demonstration
if not torch then
    _G.torch = {
        isTensor = function(obj) return obj and obj._data end,
        type = function(obj) return "MockTensor" end
    }
end

-- Step 5: Process data through the membrane network
print("\n4. Processing data through membrane network...")

local input_data = MockTensor({1.0, 2.0, 3.0, 4.0}, {4})
print("Input tensor shape:", table.concat(input_data:size():totable(), "x"))

-- Forward pass through network
local hidden_output = input_layer:forward(input_data)
local final_output = hidden_layer:forward(hidden_output)
local result = output_layer:forward(final_output)

print("✓ Forward pass completed")

-- Step 6: Examine cognitive signatures
print("\n5. Examining cognitive signatures...")

local input_lexeme = input_layer:getLexeme()
if input_lexeme then
    print("Input layer signature:", input_lexeme.gestalt_signature or "generating...")
    if input_lexeme.dimensional_signature then
        print("  Prime factors:", table.concat(input_lexeme.dimensional_signature, " | "))
    end
end

local hidden_lexeme = hidden_layer:getLexeme()
if hidden_lexeme then
    print("Hidden layer signature:", hidden_lexeme.gestalt_signature or "generating...")
end

-- Step 7: Check evolution states
print("\n6. Evolution state analysis...")

local input_evolution = input_layer:getEvolutionState()
print(string.format("Input layer: Gen=%d, Fitness=%.3f, Quantization=%.3f",
                   input_evolution.generation,
                   input_evolution.fitness,
                   input_evolution.quantization_level))

local hidden_evolution = hidden_layer:getEvolutionState()
print(string.format("Hidden layer: Gen=%d, Fitness=%.3f, Quantization=%.3f",
                   hidden_evolution.generation,
                   hidden_evolution.fitness,
                   hidden_evolution.quantization_level))

-- Step 8: Analyze system status
print("\n7. System status analysis...")

local status = P9ML.status()
print(string.format("Total membranes: %d", status.membranes.total))
print(string.format("Active membranes: %d", status.membranes.active))
print(string.format("Gestalt coherence: %.3f", status.gestalt.coherence))

if status.membranes.types then
    print("Membrane types:")
    for mtype, count in pairs(status.membranes.types) do
        print(string.format("  %s: %d", mtype, count))
    end
end

-- Step 9: Gestalt field synthesis
print("\n8. Gestalt field synthesis...")

local gestalt_field = P9ML.synthesize()
if gestalt_field then
    print(string.format("Field energy: %.3f", gestalt_field.field_energy or 0))
    print(string.format("Field coherence: %.3f", gestalt_field.coherence or 0))
    print(string.format("Components: %d", gestalt_field.components and #gestalt_field.components or 0))
    
    if gestalt_field.dimensional_summary then
        local summary = gestalt_field.dimensional_summary
        print("Dimensional analysis:")
        if summary.dimension_distribution then
            for dims, count in pairs(summary.dimension_distribution) do
                print(string.format("  %dD tensors: %d", dims, count))
            end
        end
    end
end

-- Step 10: Cognitive similarity analysis
print("\n9. Cognitive similarity analysis...")

local membranes = P9ML.getMembranes()
if #membranes >= 2 then
    local similarity = P9ML.getCognitiveSimilarity(membranes[1], membranes[2])
    print(string.format("Similarity between membrane 1 and 2: %.3f", similarity))
    
    if similarity > 0.5 then
        print("→ High cognitive similarity detected!")
    elseif similarity > 0.3 then
        print("→ Moderate cognitive similarity")
    else
        print("→ Low cognitive similarity")
    end
else
    print("Insufficient membranes for similarity analysis")
end

-- Step 11: Meta-learning demonstration
print("\n10. Meta-learning demonstration...")

print("Running additional iterations to show adaptation...")
for i = 1, 3 do
    local test_input = MockTensor({i, i+1, i+2, i+3}, {4})
    input_layer:forward(test_input)
    
    local new_evolution = input_layer:getEvolutionState()
    print(string.format("Iteration %d: Fitness=%.3f, Quantization=%.3f",
                       i, new_evolution.fitness, new_evolution.quantization_level))
end

-- Step 12: Summary
print("\n=== Tutorial Complete! ===")
print("\nKey Concepts Demonstrated:")
print("✓ Membrane creation and configuration")
print("✓ Network topology and connections") 
print("✓ Cognitive signature generation")
print("✓ Evolution and adaptation")
print("✓ Gestalt field synthesis")
print("✓ Cognitive similarity computation")
print("✓ Meta-learning and system adaptation")

print("\nNext Steps:")
print("• Explore advanced_patterns.lua for complex architectures")
print("• Read ARCHITECTURE.md for detailed technical information")
print("• Check P9ML_Cognitive_Grammar_Catalog.md for cognitive patterns")
print("• Experiment with different tensor shapes and configurations")

print("\n" .. string.rep("=", 50))