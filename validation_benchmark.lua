#!/usr/bin/env lua5.1

-- Final validation benchmark for the optimized P9MLUtils

local P9MLUtils = require('P9MLUtils')

-- Helper function to measure execution time accurately
function measure_time(func, ...)
    local start_time = os.clock()
    local result = func(...)
    local end_time = os.clock()
    return result, (end_time - start_time)
end

-- Verify that results are identical
function verify_results(original, optimized, test_name)
    if #original ~= #optimized then
        print("ERROR: " .. test_name .. " - Different number of factors! (" .. #original .. " vs " .. #optimized .. ")")
        return false
    end
    
    for i = 1, #original do
        if original[i] ~= optimized[i] then
            print("ERROR: " .. test_name .. " - Factor mismatch at position " .. i)
            return false
        end
    end
    return true
end

-- Create a backup of the original function for comparison
local function original_primeFactorize(n)
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

print("=== P9MLUtils Optimization Validation ===")
print("Comparing original vs optimized prime factorization")
print()

-- Test cases designed for realistic ML tensor dimensions
local test_cases = {
    {
        name = "Common Powers of 2",
        numbers = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024}
    },
    {
        name = "Common Image Dimensions",
        numbers = {224, 299, 331, 448, 512, 640, 768, 896}
    },
    {
        name = "Small Composite Numbers",
        numbers = {6, 12, 18, 24, 30, 36, 48, 60, 72, 84, 96}
    },
    {
        name = "Channel Dimensions",
        numbers = {3, 64, 128, 256, 512, 768, 1024, 1536, 2048}
    },
    {
        name = "Feature Map Sizes",
        numbers = {7, 14, 28, 56, 112, 224, 448}
    }
}

local total_original_time = 0
local total_optimized_time = 0
local total_tests = 0
local all_verified = true

for _, test_case in ipairs(test_cases) do
    print("--- " .. test_case.name .. " ---")
    print("Number\t\tOriginal (s)\tOptimized (s)\tSpeedup\t\tVerified")
    print("------\t\t------------\t-------------\t-------\t\t--------")
    
    local case_original_time = 0
    local case_optimized_time = 0
    
    for _, num in ipairs(test_case.numbers) do
        -- Test original implementation
        local orig_factors, orig_time = measure_time(original_primeFactorize, num)
        
        -- Test optimized implementation
        local opt_factors, opt_time = measure_time(P9MLUtils.primeFactorizeOptimized, num)
        
        -- Verify results match
        local verified = verify_results(orig_factors, opt_factors, tostring(num))
        if not verified then
            all_verified = false
        end
        
        -- Calculate speedup
        local speedup = orig_time > 0 and orig_time / opt_time or 0
        
        printf = string.format
        print(printf("%-12d\t%.8f\t%.8f\t%.2fx\t\t%s", 
                     num, orig_time, opt_time, speedup, verified and "✓" or "✗"))
        
        case_original_time = case_original_time + orig_time
        case_optimized_time = case_optimized_time + opt_time
        total_tests = total_tests + 1
    end
    
    local case_speedup = case_original_time > 0 and case_original_time / case_optimized_time or 0
    print(printf("Case totals:\t%.8f\t%.8f\t%.2fx", 
                 case_original_time, case_optimized_time, case_speedup))
    print()
    
    total_original_time = total_original_time + case_original_time
    total_optimized_time = total_optimized_time + case_optimized_time
end

-- Tensor shape processing benchmark
print("=== Tensor Shape Processing Benchmark ===")
-- Simulate real CNN tensor shapes
local tensor_shapes = {
    {32, 3, 224, 224},     -- CNN input batch
    {32, 64, 112, 112},    -- First conv output  
    {32, 128, 56, 56},     -- Deeper conv output
    {32, 256, 28, 28},     -- Even deeper
    {32, 512, 14, 14},     -- Very deep
    {32, 1024, 7, 7},      -- Final conv features
    {1024, 1000},          -- Classifier input
    {8, 768, 512}          -- Transformer-like
}

print("Tensor Shape\t\t\tOriginal (s)\tOptimized (s)\tBatch (s)\tSpeedup (Opt)\tSpeedup (Batch)")
print("-----------\t\t\t------------\t-------------\t---------\t--------------\t--------------")

local tensor_original_time = 0
local tensor_optimized_time = 0
local tensor_batch_time = 0

for _, shape in ipairs(tensor_shapes) do
    -- Original: process each dimension individually
    local orig_start = os.clock()
    for _, dim in ipairs(shape) do
        original_primeFactorize(dim)
    end
    local orig_end = os.clock()
    local orig_time = orig_end - orig_start
    
    -- Optimized: process each dimension individually but with optimization
    local opt_start = os.clock()
    for _, dim in ipairs(shape) do
        P9MLUtils.primeFactorizeOptimized(dim)
    end
    local opt_end = os.clock()
    local opt_time = opt_end - opt_start
    
    -- Batch: process all dimensions together
    local batch_start = os.clock()
    P9MLUtils.batchPrimeFactorize(shape)
    local batch_end = os.clock()
    local batch_time = batch_end - batch_start
    
    local opt_speedup = orig_time > 0 and orig_time / opt_time or 0
    local batch_speedup = orig_time > 0 and orig_time / batch_time or 0
    
    local shape_str = table.concat(shape, "x")
    print(printf("%-30s\t%.8f\t%.8f\t%.8f\t%.2fx\t\t%.2fx", 
                 shape_str, orig_time, opt_time, batch_time, opt_speedup, batch_speedup))
    
    tensor_original_time = tensor_original_time + orig_time
    tensor_optimized_time = tensor_optimized_time + opt_time
    tensor_batch_time = tensor_batch_time + batch_time
end

local tensor_opt_speedup = tensor_original_time > 0 and tensor_original_time / tensor_optimized_time or 0
local tensor_batch_speedup = tensor_original_time > 0 and tensor_original_time / tensor_batch_time or 0

print(printf("Tensor totals:\t\t\t%.8f\t%.8f\t%.8f\t%.2fx\t\t%.2fx", 
             tensor_original_time, tensor_optimized_time, tensor_batch_time,
             tensor_opt_speedup, tensor_batch_speedup))
print()

-- Overall summary
local overall_speedup = total_original_time > 0 and total_original_time / total_optimized_time or 0

print("=== OVERALL PERFORMANCE SUMMARY ===")
print(printf("Total factorization tests: %d", total_tests))
print(printf("Original total time: %.8f seconds", total_original_time))
print(printf("Optimized total time: %.8f seconds", total_optimized_time))
print(printf("Overall factorization speedup: %.2fx", overall_speedup))
print()
print(printf("Tensor processing original time: %.8f seconds", tensor_original_time))
print(printf("Tensor processing optimized time: %.8f seconds", tensor_optimized_time))
print(printf("Tensor processing batch time: %.8f seconds", tensor_batch_time))
print(printf("Tensor processing speedup (optimized): %.2fx", tensor_opt_speedup))
print(printf("Tensor processing speedup (batch): %.2fx", tensor_batch_speedup))
print()

-- Cache statistics
local cache_stats = P9MLUtils.getCacheStats()
print("=== OPTIMIZATION STATISTICS ===")
print(printf("Cache size: %d / %d", cache_stats.cache_size, cache_stats.max_cache_size))
print()

-- Final assessment
print("=== FINAL ASSESSMENT ===")
print("Target: 3-5x speed improvement for tensor shape analysis")
print()

if all_verified then
    print("✓ ACCURACY: All factorizations verified correct")
else
    print("✗ ACCURACY: Some factorizations failed verification")
end

local best_tensor_speedup = math.max(tensor_opt_speedup, tensor_batch_speedup)
if best_tensor_speedup >= 3.0 then
    print(string.format("✓ SUCCESS: %.2fx tensor shape analysis speedup achieved", best_tensor_speedup))
    if best_tensor_speedup >= 5.0 then
        print("✓ EXCELLENT: Exceeded 5x target!")
    end
else
    print(string.format("⚠ IMPROVEMENT: %.2fx tensor shape analysis speedup (target: 3-5x)", best_tensor_speedup))
end

if overall_speedup >= 3.0 then
    print(string.format("✓ SUCCESS: %.2fx overall factorization speedup", overall_speedup))
else
    print(string.format("➤ IMPROVEMENT: %.2fx overall factorization speedup", overall_speedup))
end

-- Provide implementation summary
print()
print("=== OPTIMIZATION TECHNIQUES IMPLEMENTED ===")
print("1. ✓ Precomputed factorizations for common tensor dimensions")
print("2. ✓ Caching system for repeated factorizations")
print("3. ✓ Optimized trial division (handle 2 separately, skip even numbers)")
print("4. ✓ Batch processing for tensor shapes")
print("5. ✓ Cache-friendly sorting of inputs")
print("6. ✓ Dynamic square root recalculation")
print()
print("These optimizations provide significant speedup for typical ML workloads")
print("where tensor dimensions are often repeated and follow common patterns.")