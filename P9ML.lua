-- P9ML Integration - Main module for neural-membrane integration
-- Provides convenient wrappers and initialization for the P9ML system

local P9MLUtils = require('P9MLUtils')
local P9MLMembrane = require('P9MLMembrane')
local P9MLNamespace = require('P9MLNamespace')
local P9MLCognitiveKernel = require('P9MLCognitiveKernel')

local P9ML = {}

-- Global system state
P9ML.initialized = false
P9ML.namespace = nil
P9ML.cognitive_kernel = nil

-- Initialize the P9ML system
function P9ML.init(config)
    config = config or {}
    
    print("Initializing P9ML Membrane Computing System...")
    
    -- Initialize namespace
    P9ML.namespace = P9MLNamespace:init()
    
    -- Initialize cognitive kernel
    P9ML.cognitive_kernel = P9MLCognitiveKernel:init()
    
    -- Set global references for easy access
    _G.P9ML = P9ML
    _G.P9MLNamespace = P9ML.namespace
    _G.P9MLCognitiveKernel = P9ML.cognitive_kernel
    
    P9ML.initialized = true
    
    print("✓ P9ML System initialized successfully")
    print("✓ Namespace ready for membrane registration")
    print("✓ Cognitive kernel ready for tensor encoding")
    
    return P9ML
end

-- Wrap a neural module with P9ML membrane computing
function P9ML.wrapModule(module, config)
    if not P9ML.initialized then
        P9ML.init()
    end
    
    config = config or {}
    
    -- Create membrane wrapper
    local membrane = P9MLMembrane.new(module, config)
    
    -- The membrane will auto-register with the namespace
    print("Wrapped module with membrane ID:", membrane:getId())
    
    return membrane
end

-- Convenience function to create a linear membrane
function P9ML.Linear(inputSize, outputSize, config)
    local module = {}
    
    -- Mock linear module (in real implementation would use nn.Linear)
    module.weight = {}  -- Simplified for demo
    module.bias = {}
    
    function module:forward(input)
        -- Simple linear transformation (simplified for demonstration)
        if torch and torch.isTensor and torch.isTensor(input) then
            -- In real implementation: return input * weight + bias
            return input:clone() -- Simplified
        else
            return input -- Pass through for non-tensors
        end
    end
    
    function module:backward(gradOutput)
        return gradOutput -- Simplified
    end
    
    return P9ML.wrapModule(module, config)
end

-- Convenience function to create a convolutional membrane  
function P9ML.Conv2d(inputChannels, outputChannels, kernelSize, config)
    local module = {}
    
    -- Mock conv module (in real implementation would use nn.SpatialConvolution)
    module.weight = {}  -- Simplified for demo
    module.bias = {}
    
    function module:forward(input)
        -- Simple convolution (simplified for demonstration)
        if torch and torch.isTensor and torch.isTensor(input) then
            return input:clone() -- Simplified
        else
            return input -- Pass through for non-tensors
        end
    end
    
    function module:backward(gradOutput)
        return gradOutput -- Simplified
    end
    
    return P9ML.wrapModule(module, config)
end

-- Get system status
function P9ML.status()
    if not P9ML.initialized then
        return {
            initialized = false,
            message = "P9ML system not initialized"
        }
    end
    
    local namespace_metadata = P9ML.namespace:getMetadata()
    local gestalt_state = P9ML.namespace:getGestaltState()
    local hypergraph = P9ML.cognitive_kernel:getHypergraphTopology()
    
    return {
        initialized = true,
        membranes = {
            total = namespace_metadata.total_membranes,
            active = namespace_metadata.active_membranes,
            types = namespace_metadata.membrane_types
        },
        gestalt = {
            coherence = gestalt_state.coherence_metric,
            last_synthesis = gestalt_state.last_synthesis,
            dimensional_harmony = gestalt_state.dimensional_harmony
        },
        cognitive = {
            nodes = 0,
            hyperedges = 0,
            clusters = 0
        }
    }
end

-- Update cognitive status counts
function P9ML._updateCognitiveStatus(status)
    if P9ML.cognitive_kernel then
        local hypergraph = P9ML.cognitive_kernel:getHypergraphTopology()
        
        -- Count nodes
        for _ in pairs(hypergraph.nodes) do
            status.cognitive.nodes = status.cognitive.nodes + 1
        end
        
        -- Count hyperedges
        for _ in pairs(hypergraph.hyperedges) do
            status.cognitive.hyperedges = status.cognitive.hyperedges + 1
        end
        
        -- Count clusters
        for _ in pairs(hypergraph.cognitive_clusters) do
            status.cognitive.clusters = status.cognitive.clusters + 1
        end
    end
    
    return status
end

-- Synthesize gestalt field and update cognitive state
function P9ML.synthesize()
    if not P9ML.initialized then
        error("P9ML system not initialized")
    end
    
    print("Synthesizing gestalt tensor field...")
    
    -- Synthesize gestalt field
    local gestalt_field = P9ML.namespace:synthesizeGestaltField()
    
    -- Update cognitive clusters
    if P9ML.cognitive_kernel then
        -- The kernel automatically updates when encodings are added
        local clusters = P9ML.cognitive_kernel:getCognitiveClusters()
        print("Found", tableLength(clusters), "cognitive clusters")
    end
    
    local gestalt_state = P9ML.namespace:getGestaltState()
    print("Gestalt coherence:", gestalt_state.coherence_metric)
    
    return gestalt_field
end

-- Helper function to count table length
function tableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Get all membranes in the system
function P9ML.getMembranes()
    if not P9ML.initialized then
        return {}
    end
    
    return P9ML.namespace:getAllMembranes()
end

-- Find membranes by type
function P9ML.getMembranesByType(membrane_type)
    if not P9ML.initialized then
        return {}
    end
    
    return P9ML.namespace:getMembranesByType(membrane_type)
end

-- Get cognitive similarity between membranes
function P9ML.getCognitiveSimilarity(membrane1, membrane2)
    if not P9ML.initialized or not membrane1 or not membrane2 then
        return 0.0
    end
    
    local lexeme1 = membrane1:getLexeme()
    local lexeme2 = membrane2:getLexeme()
    
    if not lexeme1 or not lexeme2 then
        return 0.0
    end
    
    return 1.0 - P9MLUtils.cognitiveDistance(lexeme1, lexeme2)
end

-- Create a sequence of connected membranes
function P9ML.createSequence(modules, configs)
    configs = configs or {}
    local membranes = {}
    
    for i, module in ipairs(modules) do
        local config = configs[i] or {}
        local membrane = P9ML.wrapModule(module, config)
        table.insert(membranes, membrane)
        
        -- Connect to previous membrane
        if i > 1 then
            membranes[i-1]:connectTo(membrane)
        end
    end
    
    return membranes
end

-- Process a tensor through a sequence of membranes
function P9ML.forwardSequence(membranes, input)
    local current_input = input
    
    for i, membrane in ipairs(membranes) do
        current_input = membrane:forward(current_input)
        
        -- Encode tensor shape in cognitive kernel
        if torch and torch.isTensor and torch.isTensor(current_input) then
            P9ML.cognitive_kernel:encodeTensorShape(
                current_input:size():totable(), 
                membrane:getId()
            )
        end
    end
    
    return current_input
end

-- Reset the P9ML system
function P9ML.reset()
    print("Resetting P9ML system...")
    
    P9ML.namespace = nil
    P9ML.cognitive_kernel = nil
    P9ML.initialized = false
    
    _G.P9MLNamespace = nil
    _G.P9MLCognitiveKernel = nil
    
    print("✓ P9ML system reset")
end

return P9ML