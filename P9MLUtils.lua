-- P9ML Utilities - Prime factorization and tensor shape analysis
-- Part of the P9ML Membrane Computing integration with Torch Neural Substrate

local P9MLUtils = {}

-- Cache for prime factorizations to avoid recomputation
local _factorization_cache = {}
local _cache_size = 0
local _max_cache_size = 500

-- Precomputed factorizations for very common tensor dimensions
local _precomputed_factors = {
    [1] = {},
    [2] = {2},
    [3] = {3},
    [4] = {2, 2},
    [5] = {5},
    [6] = {2, 3},
    [7] = {7},
    [8] = {2, 2, 2},
    [9] = {3, 3},
    [10] = {2, 5},
    [12] = {2, 2, 3},
    [14] = {2, 7},
    [16] = {2, 2, 2, 2},
    [18] = {2, 3, 3},
    [20] = {2, 2, 5},
    [24] = {2, 2, 2, 3},
    [28] = {2, 2, 7},
    [30] = {2, 3, 5},
    [32] = {2, 2, 2, 2, 2},
    [36] = {2, 2, 3, 3},
    [48] = {2, 2, 2, 2, 3},
    [56] = {2, 2, 2, 7},
    [60] = {2, 2, 3, 5},
    [64] = {2, 2, 2, 2, 2, 2},
    [112] = {2, 2, 2, 2, 7},
    [120] = {2, 2, 2, 3, 5},
    [128] = {2, 2, 2, 2, 2, 2, 2},
    [224] = {2, 2, 2, 2, 2, 7},
    [256] = {2, 2, 2, 2, 2, 2, 2, 2},
    [512] = {2, 2, 2, 2, 2, 2, 2, 2, 2},
    [1024] = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2}
}

-- Original prime factorization for tensor dimensions (kept for compatibility)
function P9MLUtils.primeFactorize(n)
    if n <= 1 then
        return {}
    end
    
    local factors = {}
    local d = 2
    
    while d * d <= n do
        while n % d == 0 do
            table.insert(factors, d)
            n = n / d
        end
        d = d + 1
    end
    
    if n > 1 then
        table.insert(factors, n)
    end
    
    return factors
end

-- Optimized prime factorization with caching and precomputation
function P9MLUtils.primeFactorizeOptimized(n)
    if n <= 1 then
        return {}
    end
    
    -- Check precomputed factors first (instant lookup)
    if _precomputed_factors[n] then
        return _precomputed_factors[n]
    end
    
    -- Check cache
    if _factorization_cache[n] then
        return _factorization_cache[n]
    end
    
    local factors = {}
    local original_n = n
    
    -- Handle 2 separately for efficiency
    while n % 2 == 0 do
        table.insert(factors, 2)
        n = n / 2
    end
    
    -- Only check odd numbers starting from 3
    local d = 3
    local sqrt_n = math.sqrt(n)
    
    while d <= sqrt_n do
        while n % d == 0 do
            table.insert(factors, d)
            n = n / d
            sqrt_n = math.sqrt(n)  -- Recalculate as n shrinks
        end
        d = d + 2  -- Skip even numbers
    end
    
    if n > 1 then
        table.insert(factors, n)
    end
    
    -- Cache the result if under limit
    if _cache_size < _max_cache_size then
        _factorization_cache[original_n] = factors
        _cache_size = _cache_size + 1
    end
    
    return factors
end

-- Batch prime factorization for tensor shapes (process all dimensions at once)
function P9MLUtils.batchPrimeFactorize(numbers)
    local results = {}
    
    -- Sort numbers to improve cache locality
    local sorted_numbers = {}
    for i, num in ipairs(numbers) do
        sorted_numbers[i] = {num, i}
    end
    
    table.sort(sorted_numbers, function(a, b) return a[1] < b[1] end)
    
    -- Process sorted numbers
    for _, pair in ipairs(sorted_numbers) do
        local num, original_index = pair[1], pair[2]
        results[original_index] = P9MLUtils.primeFactorizeOptimized(num)
    end
    
    return results
end

-- Generate lexeme from tensor shape
function P9MLUtils.tensorToLexeme(tensor)
    if not torch or not torch.isTensor or not torch.isTensor(tensor) then
        return {}
    end
    
    local shape = tensor:size():totable()
    
    -- Use batch processing for all dimensions
    local batch_factors = P9MLUtils.batchPrimeFactorize(shape)
    
    local lexeme = {
        shape = shape,
        prime_factors = batch_factors,
        dimensional_signature = {}
    }
    
    for i, factors in ipairs(batch_factors) do
        lexeme.dimensional_signature[i] = table.concat(factors, "*")
    end
    
    lexeme.gestalt_signature = table.concat(lexeme.dimensional_signature, "x")
    return lexeme
end

-- Get performance statistics
function P9MLUtils.getCacheStats()
    return {
        cache_size = _cache_size,
        max_cache_size = _max_cache_size,
        precomputed_count = 0  -- Count precomputed entries
    }
end

-- Clear factorization cache
function P9MLUtils.clearFactorizationCache()
    _factorization_cache = {}
    _cache_size = 0
end

-- Compute cognitive similarity between two lexemes
function P9MLUtils.cognitiveDistance(lexeme1, lexeme2)
    if not lexeme1 or not lexeme2 then
        return math.huge
    end
    
    local sig1 = lexeme1.gestalt_signature or ""
    local sig2 = lexeme2.gestalt_signature or ""
    
    if sig1 == sig2 then
        return 0
    end
    
    -- Simple Levenshtein-like distance for cognitive signatures
    local len1, len2 = #sig1, #sig2
    local matrix = {}
    
    for i = 0, len1 do
        matrix[i] = {[0] = i}
    end
    
    for j = 0, len2 do
        matrix[0][j] = j
    end
    
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (sig1:sub(i,i) == sig2:sub(j,j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i-1][j] + 1,
                matrix[i][j-1] + 1,
                matrix[i-1][j-1] + cost
            )
        end
    end
    
    return matrix[len1][len2] / math.max(len1, len2)
end

-- Generate unique membrane ID
function P9MLUtils.generateMembraneId()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local id = "MEM_"
    for i = 1, 8 do
        local rand = math.random(#chars)
        id = id .. chars:sub(rand, rand)
    end
    return id
end

-- Hash function for tensor states
function P9MLUtils.tensorHash(tensor)
    if not torch or not torch.isTensor or not torch.isTensor(tensor) then
        return "NULL_TENSOR"
    end
    
    local shape = tensor:size():totable()
    local hash_components = {table.concat(shape, "x")}
    
    -- Sample a few elements for hash diversity
    local numel = tensor:nElement()
    if numel > 0 then
        local sample_indices = {1}
        if numel > 1 then
            table.insert(sample_indices, math.ceil(numel / 2))
            table.insert(sample_indices, numel)
        end
        
        for _, idx in ipairs(sample_indices) do
            if idx <= numel then
                local val = tensor:storage()[idx]
                table.insert(hash_components, string.format("%.6f", val))
            end
        end
    end
    
    return table.concat(hash_components, "_")
end

return P9MLUtils