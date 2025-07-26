-- P9ML Enhanced Utils with Multiple Optimization Strategies
-- Final version targeting 3-5x performance improvement

local P9MLFinalUtils = {}

-- Multiple implementation strategies for different scenarios
local original_factorize = require('P9MLUtils').primeFactorize

-- Cache for commonly factorized numbers
local factorization_cache = {}
local cache_hits = 0
local cache_misses = 0

-- Optimized implementation with several improvements
function P9MLFinalUtils.primeFactorizeOptimized(n)
    if n <= 1 then
        return {}
    end
    
    -- Check cache first
    if factorization_cache[n] then
        cache_hits = cache_hits + 1
        return factorization_cache[n]
    end
    
    cache_misses = cache_misses + 1
    local factors = {}
    local original_n = n
    
    -- Handle 2 separately for efficiency
    while n % 2 == 0 do
        table.insert(factors, 2)
        n = n / 2
    end
    
    -- Handle odd factors starting from 3
    local candidate = 3
    local sqrt_n = math.sqrt(n)
    
    while candidate <= sqrt_n do
        while n % candidate == 0 do
            table.insert(factors, candidate)
            n = n / candidate
            sqrt_n = math.sqrt(n)  -- Recalculate as n gets smaller
        end
        candidate = candidate + 2  -- Only check odd numbers
    end
    
    -- If n is still > 1, then it's a prime
    if n > 1 then
        table.insert(factors, n)
    end
    
    -- Cache the result
    factorization_cache[original_n] = factors
    
    return factors
end

-- Segmented sieve for generating primes up to n
function P9MLFinalUtils.segmentedSieve(n)
    if n < 2 then return {} end
    
    local sqrt_n = math.floor(math.sqrt(n))
    local primes = {}
    
    -- Simple sieve for small primes up to sqrt(n)
    local is_prime = {}
    for i = 2, sqrt_n do
        is_prime[i] = true
    end
    
    for i = 2, sqrt_n do
        if is_prime[i] then
            table.insert(primes, i)
            for j = i * i, sqrt_n, i do
                is_prime[j] = false
            end
        end
    end
    
    return primes
end

-- Ultra-fast factorization for powers of 2
function P9MLFinalUtils.factorizePowerOf2(n)
    if n <= 0 then
        return nil
    end
    
    -- Check if n is a power of 2 using division method (Lua 5.1 compatible)
    local temp = n
    while temp > 1 do
        if temp % 2 ~= 0 then
            return nil  -- Not a power of 2
        end
        temp = temp / 2
    end
    
    local factors = {}
    while n > 1 do
        table.insert(factors, 2)
        n = n / 2
    end
    return factors
end

-- Fast factorization for small numbers (precomputed)
local small_factorizations = {
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
    [15] = {3, 5},
    [16] = {2, 2, 2, 2},
    [18] = {2, 3, 3},
    [20] = {2, 2, 5},
    [21] = {3, 7},
    [24] = {2, 2, 2, 3},
    [25] = {5, 5},
    [27] = {3, 3, 3},
    [28] = {2, 2, 7},
    [30] = {2, 3, 5},
    [32] = {2, 2, 2, 2, 2},
    [36] = {2, 2, 3, 3},
    [40] = {2, 2, 2, 5},
    [42] = {2, 3, 7},
    [48] = {2, 2, 2, 2, 3},
    [49] = {7, 7},
    [50] = {2, 5, 5},
    [54] = {2, 3, 3, 3},
    [56] = {2, 2, 2, 7},
    [60] = {2, 2, 3, 5},
    [64] = {2, 2, 2, 2, 2, 2},
    [72] = {2, 2, 2, 3, 3},
    [81] = {3, 3, 3, 3},
    [84] = {2, 2, 3, 7},
    [96] = {2, 2, 2, 2, 2, 3},
    [100] = {2, 2, 5, 5},
    [108] = {2, 2, 3, 3, 3},
    [112] = {2, 2, 2, 2, 7},
    [120] = {2, 2, 2, 3, 5},
    [128] = {2, 2, 2, 2, 2, 2, 2},
    [144] = {2, 2, 2, 2, 3, 3},
    [224] = {2, 2, 2, 2, 2, 7},
    [256] = {2, 2, 2, 2, 2, 2, 2, 2},
    [512] = {2, 2, 2, 2, 2, 2, 2, 2, 2},
    [1024] = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2}
}

-- Smart factorization dispatcher
function P9MLFinalUtils.smartFactorize(n)
    if n <= 1 then
        return {}
    end
    
    -- Use precomputed small factorizations
    if small_factorizations[n] then
        return small_factorizations[n]
    end
    
    -- Special case: powers of 2 (very common in ML)
    local power_of_2_factors = P9MLFinalUtils.factorizePowerOf2(n)
    if power_of_2_factors then
        return power_of_2_factors
    end
    
    -- Use optimized factorization for other numbers
    return P9MLFinalUtils.primeFactorizeOptimized(n)
end

-- Batch processing with intelligent sorting
function P9MLFinalUtils.batchSmartFactorize(numbers)
    local results = {}
    
    -- Create index array for sorting
    local indices = {}
    for i = 1, #numbers do
        indices[i] = i
    end
    
    -- Sort by size for better cache utilization
    table.sort(indices, function(a, b)
        return numbers[a] < numbers[b]
    end)
    
    -- Process in sorted order
    for _, idx in ipairs(indices) do
        results[idx] = P9MLFinalUtils.smartFactorize(numbers[idx])
    end
    
    return results
end

-- Enhanced tensor shape analysis
function P9MLFinalUtils.tensorToLexemeEnhanced(tensor_or_shape)
    local shape
    
    if type(tensor_or_shape) == "table" then
        shape = tensor_or_shape
    elseif torch and torch.isTensor and torch.isTensor(tensor_or_shape) then
        shape = tensor_or_shape:size():totable()
    else
        return {}
    end
    
    -- Use batch processing for all dimensions
    local batch_factors = P9MLFinalUtils.batchSmartFactorize(shape)
    
    local lexeme = {
        shape = shape,
        prime_factors = batch_factors,
        dimensional_signature = {}
    }
    
    -- Create dimensional signatures efficiently
    for i = 1, #shape do
        lexeme.dimensional_signature[i] = table.concat(batch_factors[i], "*")
    end
    
    lexeme.gestalt_signature = table.concat(lexeme.dimensional_signature, "x")
    return lexeme
end

-- Precompute common tensor dimensions
function P9MLFinalUtils.precomputeCommonDimensions()
    local common_dims = {}
    
    -- Powers of 2 (very common)
    for i = 0, 12 do
        table.insert(common_dims, 2^i)
    end
    
    -- Common image dimensions
    local image_dims = {224, 299, 331, 448, 640, 768, 896, 1280, 1920}
    for _, dim in ipairs(image_dims) do
        table.insert(common_dims, dim)
    end
    
    -- Common ML dimensions
    local ml_dims = {3, 7, 14, 28, 56, 112, 384, 768, 1536}
    for _, dim in ipairs(ml_dims) do
        table.insert(common_dims, dim)
    end
    
    -- Factorize all to populate cache
    for _, dim in ipairs(common_dims) do
        P9MLFinalUtils.smartFactorize(dim)
    end
    
    return #common_dims
end

-- Performance statistics
function P9MLFinalUtils.getPerformanceStats()
    local total_requests = cache_hits + cache_misses
    local hit_ratio = total_requests > 0 and (cache_hits / total_requests * 100) or 0
    
    return {
        cache_hits = cache_hits,
        cache_misses = cache_misses,
        total_requests = total_requests,
        hit_ratio = hit_ratio,
        cache_size = 0  -- Would need to count actual cache entries
    }
end

-- Clear cache and reset stats
function P9MLFinalUtils.clearCache()
    factorization_cache = {}
    cache_hits = 0
    cache_misses = 0
end

return P9MLFinalUtils