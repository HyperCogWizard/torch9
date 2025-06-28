-- P9ML Namespace - Central registry and orchestration for membrane computing
-- Manages distributed computation and state management across membranes

local P9MLUtils = require('P9MLUtils')

local P9MLNamespace = {}

-- Global membrane registry
P9MLNamespace.membranes = {}
P9MLNamespace.registry_metadata = {}
P9MLNamespace.computation_graph = {}
P9MLNamespace.gestalt_state = {
    coherence_metric = 0.0,
    last_synthesis = 0,
    tensor_field = nil,
    dimensional_harmony = {}
}

-- Initialize namespace
function P9MLNamespace:init()
    self.membranes = {}
    self.registry_metadata = {
        total_membranes = 0,
        active_membranes = 0,
        membrane_types = {},
        creation_time = os.time(),
        last_activity = os.time()
    }
    self.computation_graph = {
        nodes = {},
        edges = {},
        topology_hash = ""
    }
    
    -- Set global reference
    _G.P9MLNamespace = self
    
    return self
end

-- Register a membrane in the namespace
function P9MLNamespace:registerMembrane(membrane)
    if not membrane or not membrane.getId then
        return false
    end
    
    local id = membrane:getId()
    
    if not id then
        return false
    end
    
    -- Check if already registered
    if self.membranes[id] then
        return false
    end
    
    -- Register membrane
    self.membranes[id] = membrane
    
    -- Update metadata
    local membrane_type = membrane.membrane_type or "unknown"
    self.registry_metadata.total_membranes = self.registry_metadata.total_membranes + 1
    self.registry_metadata.active_membranes = self.registry_metadata.active_membranes + 1
    
    if not self.registry_metadata.membrane_types[membrane_type] then
        self.registry_metadata.membrane_types[membrane_type] = 0
    end
    self.registry_metadata.membrane_types[membrane_type] = 
        self.registry_metadata.membrane_types[membrane_type] + 1
    
    self.registry_metadata.last_activity = os.time()
    
    -- Update computation graph
    self:_updateComputationGraph()
    
    -- Update gestalt state
    self:_updateGestaltState()
    
    return true
end

-- Unregister a membrane
function P9MLNamespace:unregisterMembrane(membrane_id)
    if not self.membranes[membrane_id] then
        return false
    end
    
    local membrane = self.membranes[membrane_id]
    local membrane_type = membrane.membrane_type or "unknown"
    
    -- Remove from registry
    self.membranes[membrane_id] = nil
    
    -- Update metadata
    self.registry_metadata.active_membranes = self.registry_metadata.active_membranes - 1
    if self.registry_metadata.membrane_types[membrane_type] then
        self.registry_metadata.membrane_types[membrane_type] = 
            self.registry_metadata.membrane_types[membrane_type] - 1
    end
    
    self.registry_metadata.last_activity = os.time()
    
    -- Update computation graph
    self:_updateComputationGraph()
    
    return true
end

-- Get membrane by ID
function P9MLNamespace:getMembrane(membrane_id)
    return self.membranes[membrane_id]
end

-- Get all membranes
function P9MLNamespace:getAllMembranes()
    local membrane_list = {}
    for id, membrane in pairs(self.membranes) do
        table.insert(membrane_list, membrane)
    end
    return membrane_list
end

-- Get membranes by type
function P9MLNamespace:getMembranesByType(membrane_type)
    local typed_membranes = {}
    for id, membrane in pairs(self.membranes) do
        if membrane.membrane_type == membrane_type then
            table.insert(typed_membranes, membrane)
        end
    end
    return typed_membranes
end

-- Find similar membranes based on cognitive signatures
function P9MLNamespace:findSimilarMembranes(target_membrane, threshold)
    threshold = threshold or 0.5
    local similar = {}
    
    if not target_membrane or not target_membrane.getLexeme then
        return similar
    end
    
    local target_lexeme = target_membrane:getLexeme()
    if not target_lexeme then
        return similar
    end
    
    for id, membrane in pairs(self.membranes) do
        if id ~= target_membrane:getId() and membrane.getLexeme then
            local lexeme = membrane:getLexeme()
            if lexeme then
                local distance = P9MLUtils.cognitiveDistance(target_lexeme, lexeme)
                if distance <= threshold then
                    table.insert(similar, {
                        membrane = membrane,
                        distance = distance,
                        similarity = 1.0 - distance
                    })
                end
            end
        end
    end
    
    -- Sort by similarity (highest first)
    table.sort(similar, function(a, b) return a.similarity > b.similarity end)
    
    return similar
end

-- Update computation graph topology
function P9MLNamespace:_updateComputationGraph()
    self.computation_graph.nodes = {}
    self.computation_graph.edges = {}
    
    -- Add nodes for each membrane
    for id, membrane in pairs(self.membranes) do
        self.computation_graph.nodes[id] = {
            id = id,
            type = membrane.membrane_type,
            activity = membrane:getActivityLevel(),
            cognitive_signature = membrane:getCognitiveSignature()
        }
    end
    
    -- Add edges for connections
    for id, membrane in pairs(self.membranes) do
        local connections = membrane:getConnections()
        for connected_id, connection_info in pairs(connections) do
            if self.membranes[connected_id] then -- Ensure target still exists
                local edge_id = id .. "->" .. connected_id
                self.computation_graph.edges[edge_id] = {
                    source = id,
                    target = connected_id,
                    strength = connection_info.strength,
                    established = connection_info.established
                }
            end
        end
    end
    
    -- Update topology hash
    local topology_components = {}
    for node_id, _ in pairs(self.computation_graph.nodes) do
        table.insert(topology_components, node_id)
    end
    table.sort(topology_components)
    self.computation_graph.topology_hash = table.concat(topology_components, "|")
end

-- Update gestalt state and coherence metrics
function P9MLNamespace:_updateGestaltState()
    local membranes = self:getAllMembranes()
    
    if #membranes == 0 then
        self.gestalt_state.coherence_metric = 0.0
        return
    end
    
    -- Compute coherence based on membrane harmony
    local total_activity = 0.0
    local activity_variance = 0.0
    local activities = {}
    
    for _, membrane in ipairs(membranes) do
        local activity = membrane:getActivityLevel()
        table.insert(activities, activity)
        total_activity = total_activity + activity
    end
    
    local mean_activity = total_activity / #membranes
    
    -- Compute variance
    for _, activity in ipairs(activities) do
        activity_variance = activity_variance + (activity - mean_activity)^2
    end
    activity_variance = activity_variance / #membranes
    
    -- Coherence is inversely related to variance (more harmony = higher coherence)
    local coherence = math.exp(-activity_variance)
    
    -- Update gestalt state
    self.gestalt_state.coherence_metric = coherence
    self.gestalt_state.last_synthesis = os.time()
    
    -- Compute dimensional harmony
    self:_computeDimensionalHarmony(membranes)
end

-- Compute dimensional harmony across membrane lexemes
function P9MLNamespace:_computeDimensionalHarmony(membranes)
    local signature_groups = {}
    
    for _, membrane in ipairs(membranes) do
        local lexeme = membrane:getLexeme()
        if lexeme and lexeme.gestalt_signature then
            local sig = lexeme.gestalt_signature
            if not signature_groups[sig] then
                signature_groups[sig] = 0
            end
            signature_groups[sig] = signature_groups[sig] + 1
        end
    end
    
    -- Compute harmony as normalized entropy
    local total = #membranes
    local entropy = 0.0
    
    for sig, count in pairs(signature_groups) do
        local prob = count / total
        if prob > 0 then
            entropy = entropy - prob * math.log(prob)
        end
    end
    
    -- Normalize entropy
    local max_entropy = math.log(total)
    local normalized_entropy = max_entropy > 0 and entropy / max_entropy or 0
    
    self.gestalt_state.dimensional_harmony = {
        entropy = entropy,
        normalized_entropy = normalized_entropy,
        signature_diversity = 0,
        dominant_signatures = {}
    }
    
    -- Count signature diversity
    for sig, count in pairs(signature_groups) do
        self.gestalt_state.dimensional_harmony.signature_diversity = 
            self.gestalt_state.dimensional_harmony.signature_diversity + 1
        
        if count >= total * 0.1 then -- Dominant if >= 10% of membranes
            table.insert(self.gestalt_state.dimensional_harmony.dominant_signatures, {
                signature = sig,
                count = count,
                prevalence = count / total
            })
        end
    end
end

-- Synthesize gestalt tensor field
function P9MLNamespace:synthesizeGestaltField()
    local membranes = self:getAllMembranes()
    
    if #membranes == 0 then
        self.gestalt_state.tensor_field = nil
        return nil
    end
    
    -- Collect all tensor shapes and activities
    local field_components = {}
    
    for _, membrane in ipairs(membranes) do
        local lexeme = membrane:getLexeme()
        local activity = membrane:getActivityLevel()
        
        if lexeme and lexeme.shape then
            table.insert(field_components, {
                shape = lexeme.shape,
                activity = activity,
                signature = lexeme.gestalt_signature,
                membrane_id = membrane:getId()
            })
        end
    end
    
    if #field_components == 0 then
        self.gestalt_state.tensor_field = nil
        return nil
    end
    
    -- Create gestalt tensor field (simplified representation)
    local gestalt_field = {
        components = field_components,
        synthesis_time = os.time(),
        field_energy = self:_computeFieldEnergy(field_components),
        coherence = self.gestalt_state.coherence_metric,
        dimensional_summary = self:_summarizeFieldDimensions(field_components)
    }
    
    self.gestalt_state.tensor_field = gestalt_field
    
    return gestalt_field
end

-- Compute field energy from components
function P9MLNamespace:_computeFieldEnergy(components)
    local total_energy = 0.0
    
    for _, comp in ipairs(components) do
        -- Energy is activity weighted by dimensional complexity
        local dim_complexity = 1.0
        for _, dim_size in ipairs(comp.shape) do
            dim_complexity = dim_complexity * math.log(dim_size + 1)
        end
        
        total_energy = total_energy + comp.activity * dim_complexity
    end
    
    return total_energy
end

-- Summarize field dimensions
function P9MLNamespace:_summarizeFieldDimensions(components)
    local dim_counts = {}
    local shape_frequencies = {}
    
    for _, comp in ipairs(components) do
        local ndim = #comp.shape
        dim_counts[ndim] = (dim_counts[ndim] or 0) + 1
        
        local shape_str = table.concat(comp.shape, "x")
        shape_frequencies[shape_str] = (shape_frequencies[shape_str] or 0) + 1
    end
    
    return {
        dimension_distribution = dim_counts,
        shape_frequencies = shape_frequencies,
        total_components = #components
    }
end

-- Get registry metadata
function P9MLNamespace:getMetadata()
    return self.registry_metadata
end

-- Get gestalt state
function P9MLNamespace:getGestaltState()
    return self.gestalt_state
end

-- Get computation graph
function P9MLNamespace:getComputationGraph()
    return self.computation_graph
end

return P9MLNamespace