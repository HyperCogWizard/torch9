#!/usr/bin/env lua

-- Advanced P9ML Patterns
-- Demonstrates complex cognitive architectures and advanced features

print("=== P9ML Advanced Patterns ===\n")

local P9ML = require('P9ML')

-- Initialize with advanced configuration
P9ML.init({
    similarity_threshold = 0.25,
    default_quantization = 0.95,
    gestalt_update_interval = 5,
    evolution_enabled = true,
    meta_learning_enabled = true
})

print("1. Creating Multi-Branch Cognitive Architecture...")

-- Create a complex branching network
local function createAdvancedNetwork()
    -- Input processing branch
    local input_processor = P9ML.Linear(16, 32, {
        initial_quantization = 0.95,
        adaptation_rate = 0.025,
        gradient_decay = 0.99
    })
    
    -- Feature extraction branches
    local feature_branch_1 = P9ML.Linear(32, 24, {
        initial_quantization = 0.9,
        adaptation_rate = 0.02
    })
    
    local feature_branch_2 = P9ML.Linear(32, 16, {
        initial_quantization = 0.88,
        adaptation_rate = 0.018
    })
    
    -- Attention mechanism simulation
    local attention_layer = P9ML.Linear(40, 20, {  -- 24 + 16 = 40
        initial_quantization = 0.92,
        adaptation_rate = 0.015,
        fitness_momentum = 0.95
    })
    
    -- Output synthesis
    local output_synthesizer = P9ML.Linear(20, 8, {
        initial_quantization = 0.85,
        adaptation_rate = 0.01
    })
    
    -- Create connections
    input_processor:connectTo(feature_branch_1)
    input_processor:connectTo(feature_branch_2)
    feature_branch_1:connectTo(attention_layer)
    feature_branch_2:connectTo(attention_layer)
    attention_layer:connectTo(output_synthesizer)
    
    return {
        input = input_processor,
        features = {feature_branch_1, feature_branch_2},
        attention = attention_layer,
        output = output_synthesizer
    }
end

local network = createAdvancedNetwork()

print("✓ Created multi-branch architecture:")
print("  Input processor:", network.input:getId():sub(1,8) .. "...")
print("  Feature branch 1:", network.features[1]:getId():sub(1,8) .. "...")
print("  Feature branch 2:", network.features[2]:getId():sub(1,8) .. "...")
print("  Attention layer:", network.attention:getId():sub(1,8) .. "...")
print("  Output synthesizer:", network.output:getId():sub(1,8) .. "...")

print("\n2. Demonstrating Complex Tensor Shapes...")

-- Mock tensor with utility functions
local function MockTensor(data, size)
    local tensor = {
        _data = data or {},
        _size = size or {1},
        _norm_cache = nil
    }
    
    function tensor:size()
        return {
            totable = function() return tensor._size end,
            size = function(dim) return tensor._size[dim] or 1 end
        }
    end
    
    function tensor:nDimension()
        return #tensor._size
    end
    
    function tensor:nElement()
        local total = 1
        for _, s in ipairs(tensor._size) do
            total = total * s
        end
        return total
    end
    
    function tensor:norm()
        if not tensor._norm_cache then
            local sum = 0
            for _, v in ipairs(tensor._data) do
                sum = sum + v * v
            end
            tensor._norm_cache = math.sqrt(sum)
        end
        return tensor._norm_cache
    end
    
    function tensor:clone()
        local new_data = {}
        for i, v in ipairs(tensor._data) do
            new_data[i] = v
        end
        return MockTensor(new_data, tensor._size)
    end
    
    function tensor:storage()
        return tensor._data
    end
    
    return tensor
end

-- Set up mock torch
if not torch then
    _G.torch = {
        isTensor = function(obj) return obj and obj._data end,
        type = function(obj) return obj and obj._data and "MockTensor" or type(obj) end
    }
end

-- Generate data for different complexity levels
local function generateSequence(n)
    local data = {}
    for i = 1, n do
        data[i] = math.sin(i * 0.1) + math.random() * 0.1
    end
    return data
end

-- Complex tensor shapes to test cognitive grammar
local test_tensors = {
    -- Vector patterns
    {MockTensor(generateSequence(5), {5}), "Vector: 5 = [5]"},
    {MockTensor(generateSequence(8), {8}), "Vector: 8 = [2,2,2]"},
    {MockTensor(generateSequence(12), {12}), "Vector: 12 = [2,2,3]"},
    
    -- Matrix patterns
    {MockTensor(generateSequence(6), {2, 3}), "Matrix: 2×3 = [2]×[3]"},
    {MockTensor(generateSequence(16), {4, 4}), "Matrix: 4×4 = [2,2]×[2,2]"},
    {MockTensor(generateSequence(15), {3, 5}), "Matrix: 3×5 = [3]×[5]"},
    
    -- Higher-dimensional tensors
    {MockTensor(generateSequence(24), {2, 3, 4}), "Tensor: 2×3×4 = [2]×[3]×[2,2]"},
    {MockTensor(generateSequence(60), {3, 4, 5}), "Tensor: 3×4×5 = [3]×[2,2]×[5]"},
}

print("Processing diverse tensor shapes for cognitive pattern analysis...")

for i, tensor_info in ipairs(test_tensors) do
    local tensor, description = tensor_info[1], tensor_info[2]
    print(string.format("\nTensor %d: %s", i, description))
    
    -- Process through network
    local output = network.input:forward(tensor)
    local feature1 = network.features[1]:forward(output)
    local feature2 = network.features[2]:forward(output)
    
    -- Simulate attention mechanism by combining features
    -- In a real implementation, this would be more sophisticated
    local combined = MockTensor({}, {40})  -- Mock combined tensor
    local attended = network.attention:forward(combined)
    local final = network.output:forward(attended)
    
    -- Encode in cognitive kernel
    P9ML.cognitive_kernel:encodeTensorShape(tensor:size():totable(), "input_" .. i)
    
    -- Show cognitive analysis
    local lexeme = network.input:getLexeme()
    if lexeme and lexeme.gestalt_signature then
        print("  Cognitive signature:", lexeme.gestalt_signature)
    end
    
    local evolution = network.input:getEvolutionState()
    print(string.format("  Evolution: Gen=%d, Fitness=%.3f", 
                       evolution.generation, evolution.fitness))
end

print("\n3. Advanced Cognitive Analysis...")

-- Analyze hypergraph topology
local topology = P9ML.cognitive_kernel:getHypergraphTopology()
print(string.format("Hypergraph nodes: %d", 
                   topology.nodes and #topology.nodes or 0))
print(string.format("Hypergraph edges: %d", 
                   topology.edges and #topology.edges or 0))

-- Get cognitive clusters
local clusters = P9ML.cognitive_kernel:getCognitiveClusters()
print(string.format("Cognitive clusters: %d", #clusters))

for i, cluster in ipairs(clusters) do
    if i <= 3 then  -- Show first 3 clusters
        print(string.format("  Cluster %d: %d members, coherence %.3f", 
                           i, cluster.size or 0, cluster.coherence or 0))
        if cluster.dominant_category then
            print(string.format("    Dominant category: %s", cluster.dominant_category))
        end
    end
end

print("\n4. Custom Grammar Rule Demonstration...")

-- Add custom cognitive grammar rules
local success = P9ML.cognitive_kernel:addGrammarRule("fibonacci", {
    pattern = "fibonacci_sequence",
    cognitive_weight = 1.5,
    interaction_range = 0.4,
    category_function = function(shape)
        -- Custom logic for Fibonacci-like patterns
        if #shape == 1 then
            local n = shape[1]
            -- Check if n is a Fibonacci number (simplified)
            local fib_sequence = {1, 1, 2, 3, 5, 8, 13, 21, 34, 55}
            for _, fib in ipairs(fib_sequence) do
                if n == fib then return "fibonacci" end
            end
        end
        return "standard"
    end
})

if success then
    print("✓ Added custom Fibonacci grammar rule")
    
    -- Test with Fibonacci-sized tensors
    local fib_tensor = MockTensor(generateSequence(13), {13})
    local fib_output = network.input:forward(fib_tensor)
    print("  Processed Fibonacci tensor (size 13)")
else
    print("✗ Failed to add custom grammar rule")
end

print("\n5. Meta-Learning and Adaptation...")

-- Demonstrate meta-learning over multiple epochs
print("Running meta-learning simulation...")

local adaptation_history = {}

for epoch = 1, 10 do
    -- Simulate training epoch
    local epoch_tensor = MockTensor(generateSequence(16), {16})
    
    -- Process through network
    network.input:forward(epoch_tensor)
    
    -- Record adaptation metrics
    local evolution = network.input:getEvolutionState()
    table.insert(adaptation_history, {
        epoch = epoch,
        fitness = evolution.fitness,
        quantization = evolution.quantization_level,
        generation = evolution.generation
    })
    
    if epoch % 3 == 0 then
        print(string.format("  Epoch %d: Fitness=%.3f, Quantization=%.3f", 
                           epoch, evolution.fitness, evolution.quantization_level))
    end
end

-- Analyze adaptation trends
local fitness_trend = 0
local quant_trend = 0
if #adaptation_history >= 2 then
    local first = adaptation_history[1]
    local last = adaptation_history[#adaptation_history]
    fitness_trend = last.fitness - first.fitness
    quant_trend = last.quantization - first.quantization
end

print(string.format("\nAdaptation Analysis:"))
print(string.format("  Fitness trend: %+.3f", fitness_trend))
print(string.format("  Quantization trend: %+.3f", quant_trend))
print(string.format("  Total generations: %d", 
                   adaptation_history[#adaptation_history].generation))

print("\n6. Advanced Gestalt Field Analysis...")

-- Trigger comprehensive gestalt synthesis
local gestalt_field = P9ML.synthesize()

if gestalt_field then
    print(string.format("Global field energy: %.3f", gestalt_field.field_energy))
    print(string.format("Field coherence: %.3f", gestalt_field.coherence))
    
    if gestalt_field.components then
        print(string.format("Active field components: %d", #gestalt_field.components))
        
        -- Analyze component diversity
        local categories = {}
        local total_activity = 0
        
        for _, comp in ipairs(gestalt_field.components) do
            categories[comp.category or "unknown"] = (categories[comp.category or "unknown"] or 0) + 1
            total_activity = total_activity + (comp.activity or 0)
        end
        
        print("\nComponent distribution:")
        for category, count in pairs(categories) do
            print(string.format("  %s: %d components", category, count))
        end
        
        local avg_activity = #gestalt_field.components > 0 and 
                           total_activity / #gestalt_field.components or 0
        print(string.format("Average component activity: %.3f", avg_activity))
    end
    
    if gestalt_field.dimensional_summary then
        local summary = gestalt_field.dimensional_summary
        print("\nDimensional harmony analysis:")
        
        if summary.dimension_distribution then
            for dims, count in pairs(summary.dimension_distribution) do
                print(string.format("  %dD tensors: %d", dims, count))
            end
        end
        
        if summary.shape_frequencies then
            print("Most common shapes:")
            local shape_list = {}
            for shape, freq in pairs(summary.shape_frequencies) do
                table.insert(shape_list, {shape = shape, freq = freq})
            end
            
            table.sort(shape_list, function(a, b) return a.freq > b.freq end)
            
            for i = 1, math.min(3, #shape_list) do
                print(string.format("    %s: %d occurrences", 
                                   shape_list[i].shape, shape_list[i].freq))
            end
        end
    end
end

print("\n7. Performance and Efficiency Analysis...")

-- Get system status for performance metrics
local status = P9ML.status()

print(string.format("System efficiency metrics:"))
print(string.format("  Total membranes: %d", status.membranes.total))
print(string.format("  Active ratio: %.1f%%", 
                   (status.membranes.active / status.membranes.total) * 100))

if status.gestalt.dimensional_harmony then
    local harmony = status.gestalt.dimensional_harmony
    print(string.format("  Signature diversity: %d patterns", 
                       harmony.signature_diversity or 0))
    print(string.format("  Normalized entropy: %.3f", 
                       harmony.normalized_entropy or 0))
end

print("\n8. Advanced Similarity Analysis...")

-- Comprehensive similarity analysis
local membranes = P9ML.getMembranes()
local similarity_matrix = {}

print(string.format("Computing similarity matrix for %d membranes...", #membranes))

for i = 1, math.min(5, #membranes) do
    similarity_matrix[i] = {}
    for j = 1, math.min(5, #membranes) do
        if i ~= j then
            local sim = P9ML.getCognitiveSimilarity(membranes[i], membranes[j])
            similarity_matrix[i][j] = sim
        else
            similarity_matrix[i][j] = 1.0
        end
    end
end

-- Display similarity matrix
print("\nSimilarity matrix (first 5×5):")
print("     ", end="")
for j = 1, math.min(5, #membranes) do
    print(string.format("%6d", j), end="")
end
print()

for i = 1, math.min(5, #membranes) do
    print(string.format("%3d:", i), end="")
    for j = 1, math.min(5, #membranes) do
        print(string.format("%6.2f", similarity_matrix[i][j]), end="")
    end
    print()
end

-- Find most similar pairs
local max_similarity = 0
local best_pair = nil

for i = 1, #membranes do
    for j = i + 1, #membranes do
        local sim = P9ML.getCognitiveSimilarity(membranes[i], membranes[j])
        if sim > max_similarity then
            max_similarity = sim
            best_pair = {i, j}
        end
    end
end

if best_pair then
    print(string.format("\nHighest similarity: %.3f between membranes %d and %d", 
                       max_similarity, best_pair[1], best_pair[2]))
end

print("\n=== Advanced Patterns Complete! ===")
print("\nAdvanced Features Demonstrated:")
print("✓ Multi-branch cognitive architectures")
print("✓ Complex tensor shape analysis")
print("✓ Custom cognitive grammar rules")
print("✓ Meta-learning and adaptation tracking")
print("✓ Advanced gestalt field analysis")
print("✓ Performance efficiency metrics")
print("✓ Comprehensive similarity analysis")
print("✓ Hypergraph topology examination")

print("\nArchitectural Insights:")
print("• Membrane branching creates cognitive specialization")
print("• Prime factorization reveals mathematical structure")
print("• Evolution drives adaptive optimization")
print("• Gestalt synthesis emerges from local interactions")
print("• Hypergraph topology encodes relationships")

print("\n" .. string.rep("=", 50))