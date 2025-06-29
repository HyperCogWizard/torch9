#!/usr/bin/env lua5.3

-- P9ML Integration Demo - Demonstrates emergent agentic cognitive grammar
-- Shows membrane computing with neural modules for gestalt tensor synthesis

local P9ML = require('P9ML')

print("=" .. string.rep("=", 60) .. "=")
print("P9ML Membrane Computing Integration Demo")
print("Emergent Agentic Cognitive Grammar with Torch Neural Substrate")
print("=" .. string.rep("=", 60) .. "=")

-- Initialize the P9ML system
P9ML.init()

print("\n🧠 Creating Neural-Membrane Architecture...")

-- Create a simple neural network with P9ML membranes
local input_size = 4
local hidden_size = 8  
local output_size = 2

-- Create membrane-wrapped neural modules
local linear1 = P9ML.Linear(input_size, hidden_size, {
    initial_quantization = 0.9,
    adaptation_rate = 0.02,
    gradient_decay = 0.98
})

local linear2 = P9ML.Linear(hidden_size, output_size, {
    initial_quantization = 0.8,
    adaptation_rate = 0.01,
    gradient_decay = 0.99
})

-- Create convolutional membrane (simulated)
local conv1 = P9ML.Conv2d(3, 16, 3, {
    initial_quantization = 0.85,
    adaptation_rate = 0.015
})

print("✓ Created membrane-wrapped neural modules")
print("  - Linear layer:", linear1:getId())
print("  - Linear layer:", linear2:getId()) 
print("  - Conv layer:", conv1:getId())

-- Connect membranes to form computation graph
linear1:connectTo(linear2)

print("\n🌐 Processing tensors through membrane network...")

-- Create mock tensors for demonstration
local function MockTensor(data, size)
    local tensor = {
        _isTensor = true,
        _type = "MockTensor",
        _data = data or {1, 2, 3, 4},
        _size = size or {4}
    }
    
    function tensor:size()
        return {
            totable = function() return tensor._size end
        }
    end
    
    function tensor:nElement()
        local total = 1
        for _, s in ipairs(tensor._size) do
            total = total * s
        end
        return total
    end
    
    function tensor:norm()
        local sum = 0
        for _, v in ipairs(tensor._data) do
            sum = sum + v * v
        end
        return math.sqrt(sum)
    end
    
    function tensor:clone()
        local clone_data = {}
        for i, v in ipairs(tensor._data) do
            clone_data[i] = v
        end
        return MockTensor(clone_data, tensor._size)
    end
    
    function tensor:div(value)
        for i, v in ipairs(tensor._data) do
            tensor._data[i] = v / value
        end
        return tensor
    end
    
    function tensor:mul(value)
        for i, v in ipairs(tensor._data) do
            tensor._data[i] = v * value
        end
        return tensor
    end
    
    function tensor:round()
        for i, v in ipairs(tensor._data) do
            tensor._data[i] = math.floor(v + 0.5)
        end
        return tensor
    end
    
    function tensor:storage()
        return tensor._data
    end
    
    return tensor
end

-- Set up mock torch for the demo
if not torch then
    _G.torch = {
        isTensor = function(obj) return obj and obj._isTensor end,
        type = function(obj) return obj and obj._type or type(obj) end
    }
end

-- Helper function to create sequence
function seq(n)
    local result = {}
    for i = 1, n do
        result[i] = i
    end
    return result
end

-- Process different tensor shapes to create diverse lexemes
local inputs = {
    MockTensor({1, 2, 3, 4}, {4}),           -- Vector: 4 = [2,2]
    MockTensor({1, 2, 3, 4, 5, 6}, {2, 3}),  -- Matrix: 2x3 = [2]x[3]  
    MockTensor({1, 2, 3, 4, 5, 6, 7, 8}, {2, 2, 2}), -- Tensor: 2x2x2 = [2]x[2]x[2]
    MockTensor({1, 2, 3, 4, 5}, {5}),        -- Vector: 5 = [5]
    MockTensor(seq(16), {4, 4}),             -- Matrix: 4x4 = [2,2]x[2,2]
}

function seq(n)
    local result = {}
    for i = 1, n do
        result[i] = i
    end
    return result
end

-- Process through network to generate cognitive lexemes
print("\n📊 Processing tensors and generating cognitive lexemes...")

for i, input in ipairs(inputs) do
    print(string.format("\nInput %d: Shape %s", i, table.concat(input:size():totable(), "x")))
    
    -- Forward pass through membrane network
    local hidden = linear1:forward(input)
    local output = linear2:forward(hidden)
    
    -- Also process through conv layer
    conv1:forward(input)
    
    -- Encode shapes in cognitive kernel
    P9ML.cognitive_kernel:encodeTensorShape(input:size():totable(), "input_" .. i)
    P9ML.cognitive_kernel:encodeTensorShape(hidden:size():totable(), linear1:getId())
    P9ML.cognitive_kernel:encodeTensorShape(output:size():totable(), linear2:getId())
    
    -- Show lexeme generation
    local lexeme = linear1:getLexeme()
    if lexeme then
        print("  Cognitive signature:", lexeme.gestalt_signature or "none")
        print("  Prime factors:", table.concat(lexeme.dimensional_signature or {}, " | "))
    end
    
    -- Show evolution state
    local evolution = linear1:getEvolutionState()
    print(string.format("  Evolution: Gen=%d, Fitness=%.3f, Quantization=%.3f", 
                       evolution.generation, evolution.fitness, evolution.quantization_level))
end

print("\n🎯 Synthesizing gestalt tensor field...")

-- Synthesize gestalt field
local gestalt_field = P9ML.synthesize()

-- Show system status
local status = P9ML.status()
P9ML._updateCognitiveStatus(status)

print("\n📈 System Status:")
print(string.format("  Membranes: %d total, %d active", status.membranes.total, status.membranes.active))
print(string.format("  Gestalt coherence: %.3f", status.gestalt.coherence))
print(string.format("  Cognitive nodes: %d", status.cognitive.nodes))
print(string.format("  Hyperedges: %d", status.cognitive.hyperedges))
print(string.format("  Clusters: %d", status.cognitive.clusters))

print("\n🔗 Analyzing cognitive similarities...")

-- Find similar membranes
local membranes = P9ML.getMembranes()
if #membranes >= 2 then
    local similarity = P9ML.getCognitiveSimilarity(membranes[1], membranes[2])
    print(string.format("  Similarity between %s and %s: %.3f", 
                       membranes[1]:getId():sub(1,8), 
                       membranes[2]:getId():sub(1,8), 
                       similarity))
end

-- Show membrane types
print("\n🏷️  Membrane Types:")
for mtype, count in pairs(status.membranes.types) do
    print(string.format("  %s: %d membranes", mtype, count))
end

print("\n🧬 Dimensional Harmony Analysis:")
if status.gestalt.dimensional_harmony then
    local harmony = status.gestalt.dimensional_harmony
    print(string.format("  Signature diversity: %d unique patterns", 
                       harmony.signature_diversity or 0))
    print(string.format("  Normalized entropy: %.3f", 
                       harmony.normalized_entropy or 0))
    
    if harmony.dominant_signatures then
        print("  Dominant cognitive signatures:")
        for _, sig_info in ipairs(harmony.dominant_signatures) do
            print(string.format("    %s (%.1f%% prevalence)", 
                               sig_info.signature, sig_info.prevalence * 100))
        end
    end
end

print("\n🎭 Evolution and Meta-Learning:")

-- Run additional forward passes to show evolution
print("  Running meta-learning iterations...")
for iter = 1, 5 do
    local test_input = MockTensor({iter, iter+1, iter+2, iter+3}, {4})
    linear1:forward(test_input)
    linear2:forward(test_input)
    
    if iter % 2 == 0 then
        local evo_state = linear1:getEvolutionState()
        print(string.format("    Iteration %d: Fitness=%.3f, Quantization=%.3f", 
                           iter, evo_state.fitness, evo_state.quantization_level))
    end
end

print("\n🚀 Relevance Realization Metrics:")

-- Compute frame problem resolution metrics
local total_activity = 0
local active_membranes = 0

for _, membrane in ipairs(membranes) do
    local activity = membrane:getActivityLevel()
    if activity > 0.1 then
        active_membranes = active_membranes + 1
    end
    total_activity = total_activity + activity
end

local avg_activity = #membranes > 0 and total_activity / #membranes or 0
local activation_ratio = #membranes > 0 and active_membranes / #membranes or 0

print(string.format("  Average membrane activity: %.3f", avg_activity))
print(string.format("  Active membrane ratio: %.3f", activation_ratio))
print(string.format("  Gestalt field components: %d", 
                   gestalt_field and gestalt_field.components and #gestalt_field.components or 0))

if gestalt_field and gestalt_field.field_energy then
    print(string.format("  Total field energy: %.3f", gestalt_field.field_energy))
end

print("\n✨ P9ML Cognitive Grammar Summary:")
print("  ✓ Membrane computing integrated with neural substrate")
print("  ✓ Prime factorization lexemes generated from tensor shapes")
print("  ✓ Hypergraph topology established for cognitive similarity")
print("  ✓ Gestalt tensor field synthesized with coherence tracking")
print("  ✓ Evolution rules applied for adaptive membrane behavior")
print("  ✓ Meta-learning loops demonstrated for topology adaptation")
print("  ✓ Relevance realization metrics computed for frame problem resolution")

print("\n" .. string.rep("=", 62))
print("🎉 P9ML Emergent Agentic Cognitive Grammar Demo Complete!")
print("Ready for ggml kernel synthesis and future LLM integration.")
print(string.rep("=", 62))

-- Optional: Reset system for clean state
-- P9ML.reset()

os.exit(0)