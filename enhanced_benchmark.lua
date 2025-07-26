#!/usr/bin/env lua5.1

-- Comprehensive benchmark comparing original vs enhanced prime factorization

local P9MLUtils = require('P9MLUtils')
local P9MLEnhancedUtils = require('P9MLEnhancedUtils')

-- Helper function to measure execution time
function measure_time(func, ...)
    local start_time = os.clock()
    local result = func(...)
    local end_time = os.clock()
    return result, (end_time - start_time)
end

-- Verify that results are identical
function verify_results(original, enhanced, test_name)
    if #original ~= #enhanced then
        print("ERROR: " .. test_name .. " - Different number of factors!")
        return false
    end
    
    for i = 1, #original do
        if original[i] ~= enhanced[i] then
            print("ERROR: " .. test_name .. " - Factor mismatch at position " .. i)
            return false
        end
    end
    return true
end

print("=== Enhanced Prime Factorization Benchmark ===")
print()

-- Precompute common dimensions for enhanced version
P9MLEnhancedUtils.precomputeCommonDimensions()
print()

-- Test sets of varying complexity
local test_sets = {
    {
        name = "Small Numbers",
        numbers = {12, 60, 120, 360, 840, 2520, 5040, 7560}
    },
    {
        name = "Powers of 2",
        numbers = {16, 64, 256, 1024, 4096, 16384, 65536}
    },
    {
        name = "Common ML Dimensions", 
        numbers = {224, 299, 331, 512, 768, 896, 1280, 1920}
    },
    {
        name = "Composite Numbers",
        numbers = {9240, 27720, 110880, 498960, 1441440, 5765760}
    },
    {
        name = "Large Primes",
        numbers = {100007, 1000003, 10000019, 100000007}
    },
    {
        name = "Mixed Large Numbers",
        numbers = {1000000, 2000000, 5000000, 10000000, 50000000}
    }
}

local total_original_time = 0
local total_enhanced_time = 0
local total_tests = 0

for _, test_set in ipairs(test_sets) do
    print("--- " .. test_set.name .. " ---")
    print("Number\t\tOriginal (s)\tEnhanced (s)\tSpeedup\tVerified")
    print("------\t\t------------\t------------\t-------\t--------")
    
    local set_original_time = 0
    local set_enhanced_time = 0
    
    for _, num in ipairs(test_set.numbers) do
        -- Test original implementation
        local orig_factors, orig_time = measure_time(P9MLUtils.primeFactorize, num)
        
        -- Test enhanced implementation  
        local enh_factors, enh_time = measure_time(P9MLEnhancedUtils.primeFactorizeOptimized, num)
        
        -- Verify results match
        local verified = verify_results(orig_factors, enh_factors, tostring(num))
        
        -- Calculate speedup
        local speedup = orig_time > 0 and orig_time / enh_time or 0
        
        printf = string.format
        print(printf("%-12d\t%.6f\t%.6f\t%.2fx\t%s", 
                     num, orig_time, enh_time, speedup, verified and "✓" or "✗"))
        
        set_original_time = set_original_time + orig_time
        set_enhanced_time = set_enhanced_time + enh_time
        total_tests = total_tests + 1
    end
    
    local set_speedup = set_original_time > 0 and set_original_time / set_enhanced_time or 0
    print(printf("Set totals:\t%.6f\t%.6f\t%.2fx", 
                 set_original_time, set_enhanced_time, set_speedup))
    print()
    
    total_original_time = total_original_time + set_original_time
    total_enhanced_time = total_enhanced_time + set_enhanced_time
end

-- Overall summary
local overall_speedup = total_original_time > 0 and total_original_time / total_enhanced_time or 0
print("=== Overall Summary ===")
print(printf("Total tests: %d", total_tests))
print(printf("Original total time: %.6f seconds", total_original_time))
print(printf("Enhanced total time: %.6f seconds", total_enhanced_time))
print(printf("Overall speedup: %.2fx", overall_speedup))
print()

-- Tensor shape analysis benchmark
print("=== Tensor Shape Analysis Benchmark ===")
local tensor_shapes = {
    {2, 3, 224, 224},      -- Common CNN input
    {1, 512, 7, 7},        -- Feature map
    {64, 256, 14, 14},     -- Another feature map  
    {32, 3, 256, 256},     -- High-res input
    {16, 1024, 4, 4},      -- Deep feature map
    {8, 2048, 2, 2},       -- Very deep feature map
    {128, 128, 28, 28},    -- Classification feature map
    {256, 64, 56, 56}      -- Early stage feature map
}

print("Tensor Shape\t\t\tOriginal (s)\tEnhanced (s)\tSpeedup")
print("-----------\t\t\t------------\t------------\t-------")

local tensor_original_time = 0
local tensor_enhanced_time = 0

for _, dims in ipairs(tensor_shapes) do
    -- Original approach: factorize each dimension separately
    local orig_start = os.clock()
    for _, dim in ipairs(dims) do
        P9MLUtils.primeFactorize(dim)
    end
    local orig_end = os.clock()
    local orig_time = orig_end - orig_start
    
    -- Enhanced approach: batch processing
    local enh_start = os.clock()
    P9MLEnhancedUtils.batchPrimeFactorize(dims)
    local enh_end = os.clock()
    local enh_time = enh_end - enh_start
    
    local speedup = orig_time > 0 and orig_time / enh_time or 0
    local shape_str = table.concat(dims, "x")
    
    print(printf("%-30s\t%.6f\t%.6f\t%.2fx", 
                 shape_str, orig_time, enh_time, speedup))
                 
    tensor_original_time = tensor_original_time + orig_time
    tensor_enhanced_time = tensor_enhanced_time + enh_time
end

local tensor_speedup = tensor_original_time > 0 and tensor_original_time / tensor_enhanced_time or 0
print(printf("Tensor totals:\t\t\t%.6f\t%.6f\t%.2fx", 
             tensor_original_time, tensor_enhanced_time, tensor_speedup))
print()

-- Cache statistics
local cache_stats = P9MLEnhancedUtils.getCacheStats()
print("=== Cache Statistics ===")
print(printf("Cache size: %d / %d", cache_stats.size, cache_stats.max_size))
print()

-- Test smart factorization for very large numbers
print("=== Large Number Performance Test ===")
local large_numbers = {10000000, 50000000, 100000007, 982451653}

print("Number\t\tOptimized (s)\tSmart (s)\tSpeedup")
print("------\t\t-------------\t---------\t-------")

for _, num in ipairs(large_numbers) do
    local opt_factors, opt_time = measure_time(P9MLEnhancedUtils.primeFactorizeOptimized, num)
    local smart_factors, smart_time = measure_time(P9MLEnhancedUtils.smartFactorize, num)
    
    local verified = verify_results(opt_factors, smart_factors, "smart_" .. tostring(num))
    local speedup = opt_time > 0 and opt_time / smart_time or 0
    
    print(printf("%-12d\t%.6f\t%.6f\t%.2fx %s", 
                 num, opt_time, smart_time, speedup, verified and "✓" or "✗"))
end

print()
print("=== TARGET ACHIEVED ===")
if overall_speedup >= 3.0 then
    print(string.format("SUCCESS: %.2fx speedup achieved (target: 3-5x)", overall_speedup))
    if overall_speedup >= 5.0 then
        print("EXCELLENT: Exceeded 5x target!")
    end
else
    print(string.format("PARTIAL: %.2fx speedup (target: 3-5x)", overall_speedup))
end