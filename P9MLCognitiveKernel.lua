-- P9ML Cognitive Kernel - Encodes tensor shapes and grammar rules for cognitive similarity
-- Establishes hypergraph topology for agent interaction and gestalt synthesis

local P9MLUtils = require('P9MLUtils')

local P9MLCognitiveKernel = {}

-- Initialize cognitive kernel
function P9MLCognitiveKernel:init()
    self.grammar_rules = {}
    self.tensor_encodings = {}
    self.hypergraph = {
        nodes = {},
        hyperedges = {},
        cognitive_clusters = {}
    }
    self.similarity_matrix = {}
    self.gestalt_synthesis_rules = {}
    
    -- Initialize with basic grammar rules
    self:_initializeBasicGrammar()
    
    return self
end

-- Initialize basic cognitive grammar rules
function P9MLCognitiveKernel:_initializeBasicGrammar()
    -- Basic dimensional grammar rules
    self.grammar_rules = {
        -- Scalar rules
        ["scalar"] = {
            pattern = "1",
            cognitive_weight = 1.0,
            interaction_range = 0.1
        },
        
        -- Vector rules
        ["vector"] = {
            pattern = "N",
            cognitive_weight = 1.2,
            interaction_range = 0.2
        },
        
        -- Matrix rules
        ["matrix"] = {
            pattern = "NxM",
            cognitive_weight = 1.5,
            interaction_range = 0.3
        },
        
        -- Tensor rules (3D+)
        ["tensor"] = {
            pattern = "NxMx...",
            cognitive_weight = 2.0,
            interaction_range = 0.4
        },
        
        -- Prime-based rules
        ["prime_simple"] = {
            pattern = "p", -- single prime
            cognitive_weight = 0.8,
            interaction_range = 0.15
        },
        
        ["prime_composite"] = {
            pattern = "p*q*...", -- multiple primes
            cognitive_weight = 1.8,
            interaction_range = 0.35
        }
    }
    
    -- Gestalt synthesis rules
    self.gestalt_synthesis_rules = {
        coherence_threshold = 0.6,
        cluster_merge_threshold = 0.7,
        hyperedge_strength_decay = 0.95,
        cognitive_resonance_factor = 1.2
    }
end

-- Encode tensor shape into cognitive representation
function P9MLCognitiveKernel:encodeTensorShape(tensor_shape, membrane_id)
    if not tensor_shape or #tensor_shape == 0 then
        return nil
    end
    
    local encoding = {
        shape = tensor_shape,
        membrane_id = membrane_id,
        prime_factorization = {},
        cognitive_category = self:_categorizeTensorShape(tensor_shape),
        encoding_time = os.time()
    }
    
    -- Compute prime factorizations for each dimension
    for i, dim in ipairs(tensor_shape) do
        encoding.prime_factorization[i] = P9MLUtils.primeFactorize(dim)
    end
    
    -- Generate cognitive signature
    encoding.cognitive_signature = self:_generateCognitiveSignature(encoding)
    
    -- Store encoding
    local shape_key = table.concat(tensor_shape, "x")
    if not self.tensor_encodings[shape_key] then
        self.tensor_encodings[shape_key] = {}
    end
    table.insert(self.tensor_encodings[shape_key], encoding)
    
    -- Update hypergraph
    self:_updateHypergraph(encoding)
    
    return encoding
end

-- Categorize tensor shape according to cognitive rules
function P9MLCognitiveKernel:_categorizeTensorShape(shape)
    local ndim = #shape
    
    -- Basic categorization
    if ndim == 0 then
        return "scalar"
    elseif ndim == 1 then
        return "vector"
    elseif ndim == 2 then
        return "matrix"
    else
        return "tensor"
    end
end

-- Generate cognitive signature for tensor encoding
function P9MLCognitiveKernel:_generateCognitiveSignature(encoding)
    local signature_parts = {}
    
    -- Add category
    table.insert(signature_parts, encoding.cognitive_category)
    
    -- Add prime structure
    local prime_patterns = {}
    for i, factors in ipairs(encoding.prime_factorization) do
        if #factors == 0 then
            table.insert(prime_patterns, "0")
        elseif #factors == 1 then
            table.insert(prime_patterns, "p" .. factors[1])
        else
            table.insert(prime_patterns, "c" .. table.concat(factors, "*"))
        end
    end
    table.insert(signature_parts, table.concat(prime_patterns, ":"))
    
    return table.concat(signature_parts, "_")
end

-- Update hypergraph with new encoding
function P9MLCognitiveKernel:_updateHypergraph(encoding)
    local node_id = encoding.membrane_id
    
    -- Add or update node
    self.hypergraph.nodes[node_id] = {
        encoding = encoding,
        cognitive_signature = encoding.cognitive_signature,
        category = encoding.cognitive_category,
        update_time = os.time(),
        interaction_strength = 1.0
    }
    
    -- Find cognitive similarities and create hyperedges
    self:_createCognitiveHyperedges(node_id, encoding)
    
    -- Update cognitive clusters
    self:_updateCognitiveClusters()
end

-- Create hyperedges based on cognitive similarity
function P9MLCognitiveKernel:_createCognitiveHyperedges(node_id, encoding)
    local signature = encoding.cognitive_signature
    
    -- Find similar nodes
    local similar_nodes = {}
    for other_id, other_node in pairs(self.hypergraph.nodes) do
        if other_id ~= node_id then
            local similarity = self:_computeCognitiveSimilarity(
                encoding, other_node.encoding)
            
            if similarity > 0.3 then -- Threshold for hyperedge creation
                table.insert(similar_nodes, {
                    id = other_id,
                    similarity = similarity
                })
            end
        end
    end
    
    -- Create hyperedges for similar nodes
    for _, similar in ipairs(similar_nodes) do
        local edge_id = node_id .. "<->" .. similar.id
        local reverse_edge_id = similar.id .. "<->" .. node_id
        
        -- Avoid duplicate edges
        if not self.hypergraph.hyperedges[edge_id] and 
           not self.hypergraph.hyperedges[reverse_edge_id] then
            
            self.hypergraph.hyperedges[edge_id] = {
                nodes = {node_id, similar.id},
                strength = similar.similarity,
                creation_time = os.time(),
                interaction_count = 0,
                cognitive_resonance = self:_computeResonance(encoding, 
                    self.hypergraph.nodes[similar.id].encoding)
            }
        end
    end
end

-- Compute cognitive similarity between two encodings
function P9MLCognitiveKernel:_computeCognitiveSimilarity(encoding1, encoding2)
    if not encoding1 or not encoding2 then
        return 0.0
    end
    
    local similarity = 0.0
    
    -- Category similarity
    if encoding1.cognitive_category == encoding2.cognitive_category then
        similarity = similarity + 0.4
    end
    
    -- Shape similarity
    if #encoding1.shape == #encoding2.shape then
        similarity = similarity + 0.3
        
        local shape_match = 0.0
        for i = 1, #encoding1.shape do
            if encoding1.shape[i] == encoding2.shape[i] then
                shape_match = shape_match + 1.0
            end
        end
        similarity = similarity + 0.3 * (shape_match / #encoding1.shape)
    end
    
    -- Prime structure similarity
    local prime_similarity = self:_computePrimeSimilarity(
        encoding1.prime_factorization, encoding2.prime_factorization)
    similarity = similarity + 0.2 * prime_similarity
    
    return math.min(1.0, similarity)
end

-- Compute similarity between prime factorizations
function P9MLCognitiveKernel:_computePrimeSimilarity(primes1, primes2)
    if #primes1 ~= #primes2 then
        return 0.0
    end
    
    local similarity = 0.0
    local total_dims = #primes1
    
    for i = 1, total_dims do
        local factors1 = primes1[i] or {}
        local factors2 = primes2[i] or {}
        
        -- Compare factor sets
        local common_factors = 0
        local total_factors = math.max(#factors1, #factors2)
        
        if total_factors == 0 then
            common_factors = 1 -- Both empty
        else
            for _, factor in ipairs(factors1) do
                for _, other_factor in ipairs(factors2) do
                    if factor == other_factor then
                        common_factors = common_factors + 1
                        break
                    end
                end
            end
        end
        
        local dim_similarity = total_factors > 0 and common_factors / total_factors or 1.0
        similarity = similarity + dim_similarity
    end
    
    return total_dims > 0 and similarity / total_dims or 0.0
end

-- Compute cognitive resonance between encodings
function P9MLCognitiveKernel:_computeResonance(encoding1, encoding2)
    local similarity = self:_computeCognitiveSimilarity(encoding1, encoding2)
    local resonance_factor = self.gestalt_synthesis_rules.cognitive_resonance_factor
    
    -- Resonance amplifies similarity based on cognitive categories
    local category_amplifier = 1.0
    if encoding1.cognitive_category == encoding2.cognitive_category then
        category_amplifier = resonance_factor
    end
    
    return similarity * category_amplifier
end

-- Update cognitive clusters based on hypergraph structure
function P9MLCognitiveKernel:_updateCognitiveClusters()
    self.hypergraph.cognitive_clusters = {}
    
    local visited = {}
    local cluster_id = 0
    
    -- Use connected components algorithm to find clusters
    for node_id, _ in pairs(self.hypergraph.nodes) do
        if not visited[node_id] then
            cluster_id = cluster_id + 1
            local cluster = self:_exploreCluster(node_id, visited)
            
            if #cluster > 0 then
                self.hypergraph.cognitive_clusters[cluster_id] = {
                    nodes = cluster,
                    center = self:_computeClusterCenter(cluster),
                    coherence = self:_computeClusterCoherence(cluster),
                    dominant_category = self:_findDominantCategory(cluster)
                }
            end
        end
    end
end

-- Explore connected nodes to form cluster
function P9MLCognitiveKernel:_exploreCluster(start_node, visited)
    local cluster = {}
    local stack = {start_node}
    
    while #stack > 0 do
        local current = table.remove(stack)
        
        if not visited[current] then
            visited[current] = true
            table.insert(cluster, current)
            
            -- Find connected nodes
            for edge_id, edge in pairs(self.hypergraph.hyperedges) do
                if edge.strength > self.gestalt_synthesis_rules.cluster_merge_threshold then
                    for _, node in ipairs(edge.nodes) do
                        if node == current then
                            for _, connected_node in ipairs(edge.nodes) do
                                if connected_node ~= current and not visited[connected_node] then
                                    table.insert(stack, connected_node)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return cluster
end

-- Compute cluster center (representative node)
function P9MLCognitiveKernel:_computeClusterCenter(cluster)
    -- Simple approach: find node with highest total connectivity
    local max_connectivity = 0
    local center_node = cluster[1]
    
    for _, node_id in ipairs(cluster) do
        local connectivity = 0
        
        for edge_id, edge in pairs(self.hypergraph.hyperedges) do
            for _, edge_node in ipairs(edge.nodes) do
                if edge_node == node_id then
                    connectivity = connectivity + edge.strength
                    break
                end
            end
        end
        
        if connectivity > max_connectivity then
            max_connectivity = connectivity
            center_node = node_id
        end
    end
    
    return center_node
end

-- Compute cluster coherence
function P9MLCognitiveKernel:_computeClusterCoherence(cluster)
    if #cluster <= 1 then
        return 1.0
    end
    
    local total_similarity = 0.0
    local pair_count = 0
    
    for i = 1, #cluster do
        for j = i + 1, #cluster do
            local node1 = self.hypergraph.nodes[cluster[i]]
            local node2 = self.hypergraph.nodes[cluster[j]]
            
            if node1 and node2 then
                local similarity = self:_computeCognitiveSimilarity(
                    node1.encoding, node2.encoding)
                total_similarity = total_similarity + similarity
                pair_count = pair_count + 1
            end
        end
    end
    
    return pair_count > 0 and total_similarity / pair_count or 0.0
end

-- Find dominant category in cluster
function P9MLCognitiveKernel:_findDominantCategory(cluster)
    local category_counts = {}
    
    for _, node_id in ipairs(cluster) do
        local node = self.hypergraph.nodes[node_id]
        if node and node.encoding then
            local category = node.encoding.cognitive_category
            category_counts[category] = (category_counts[category] or 0) + 1
        end
    end
    
    local max_count = 0
    local dominant_category = "unknown"
    
    for category, count in pairs(category_counts) do
        if count > max_count then
            max_count = count
            dominant_category = category
        end
    end
    
    return dominant_category
end

-- Get cognitive kernel state
function P9MLCognitiveKernel:getState()
    return {
        grammar_rules = self.grammar_rules,
        tensor_encodings = self.tensor_encodings,
        hypergraph = self.hypergraph,
        gestalt_synthesis_rules = self.gestalt_synthesis_rules
    }
end

-- Get hypergraph topology
function P9MLCognitiveKernel:getHypergraphTopology()
    return self.hypergraph
end

-- Get cognitive clusters
function P9MLCognitiveKernel:getCognitiveClusters()
    return self.hypergraph.cognitive_clusters
end

-- Add custom grammar rule
function P9MLCognitiveKernel:addGrammarRule(name, rule)
    if name and rule then
        self.grammar_rules[name] = rule
        return true
    end
    return false
end

-- Query encodings by category
function P9MLCognitiveKernel:queryEncodingsByCategory(category)
    local results = {}
    
    for shape_key, encodings in pairs(self.tensor_encodings) do
        for _, encoding in ipairs(encodings) do
            if encoding.cognitive_category == category then
                table.insert(results, encoding)
            end
        end
    end
    
    return results
end

return P9MLCognitiveKernel