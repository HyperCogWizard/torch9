#!/usr/bin/env lua5.1

-- Final comprehensive benchmark comparing all implementations

local P9MLUtils = require('P9MLUtils')
local P9MLEnhancedUtils = require('P9MLEnhancedUtils') 
local P9MLFinalUtils = require('P9MLFinalUtils')

-- Helper function to measure execution time accurately
function measure_time(func, ...)
    local start_time = os.clock()
    local result = func(...)
    local end_time = os.clock()
    return result, (end_time - start_time)
end

-- Verify that results are identical
function verify_results(original, enhanced, test_name)
    if #original ~= #enhanced then
        print("ERROR: " .. test_name .. " - Different number of factors! (" .. #original .. " vs " .. #enhanced .. ")")
        return false
    end
    
    for i = 1, #original do
        if original[i] ~= enhanced[i] then
            print("ERROR: " .. test_name .. " - Factor mismatch at position " .. i .. " (" .. original[i] .. " vs " .. enhanced[i] .. ")")
            return false
        end
    end
    return true
end

print("=== FINAL Prime Factorization Performance Benchmark ===")
print("Testing original vs enhanced vs final optimized implementations")
print()

-- Precompute common dimensions for both enhanced versions
print("Precomputing common dimensions...")
P9MLEnhancedUtils.precomputeCommonDimensions()
local final_precomputed = P9MLFinalUtils.precomputeCommonDimensions()
print(string.format("Final implementation precomputed %d dimensions", final_precomputed))
print()

-- Test scenarios focusing on realistic ML workloads
local test_scenarios = {
    {
        name = "Tensor Shape Dimensions",
        description = "Common tensor shape dimensions from real ML workloads",
        numbers = {2, 3, 4, 7, 8, 14, 16, 28, 32, 56, 64, 112, 128, 224, 256, 512, 1024}
    },
    {
        name = "Powers of 2",
        description = "Very common in neural networks",
        numbers = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096}
    },
    {
        name = "Image Dimensions", 
        description = "Common image processing dimensions",
        numbers = {224, 299, 331, 448, 512, 640, 768, 896, 1280, 1920}
    },
    {
        name = "Composite Numbers",
        description = "Numbers with many factors",
        numbers = {60, 120, 360, 840, 2520, 5040, 9240, 27720, 110880}
    },
    {
        name = "Large Numbers",
        description = "Performance test with larger numbers",
        numbers = {100000, 500000, 1000000, 2000000, 5000000}
    }
}

local overall_original_time = 0
local overall_enhanced_time = 0
local overall_final_time = 0
local total_tests = 0

for _, scenario in ipairs(test_scenarios) do
    print("--- " .. scenario.name .. " ---")
    print(scenario.description)
    print("Number\t\tOriginal\tEnhanced\tFinal\t\tSpeedup(E)\tSpeedup(F)\tVerified")
    print("------\t\t--------\t--------\t-----\t\t----------\t----------\t--------")
    
    local scenario_orig_time = 0
    local scenario_enh_time = 0  
    local scenario_final_time = 0
    
    for _, num in ipairs(scenario.numbers) do
        -- Test original implementation
        local orig_factors, orig_time = measure_time(P9MLUtils.primeFactorize, num)
        
        -- Test enhanced implementation
        local enh_factors, enh_time = measure_time(P9MLEnhancedUtils.primeFactorizeOptimized, num)
        
        -- Test final implementation
        local final_factors, final_time = measure_time(P9MLFinalUtils.smartFactorize, num)
        
        -- Verify results
        local enh_verified = verify_results(orig_factors, enh_factors, "enhanced_" .. tostring(num))
        local final_verified = verify_results(orig_factors, final_factors, "final_" .. tostring(num))
        
        -- Calculate speedups
        local enh_speedup = orig_time > 0 and orig_time / enh_time or 0
        local final_speedup = orig_time > 0 and orig_time / final_time or 0
        
        printf = string.format
        print(printf("%-12d\t%.6f\t%.6f\t%.6f\t%.2fx\t\t%.2fx\t\t%s/%s", 
                     num, orig_time, enh_time, final_time, enh_speedup, final_speedup,
                     enh_verified and "✓" or "✗", final_verified and "✓" or "✗"))
        
        scenario_orig_time = scenario_orig_time + orig_time
        scenario_enh_time = scenario_enh_time + enh_time
        scenario_final_time = scenario_final_time + final_time
        total_tests = total_tests + 1
    end
    
    local scenario_enh_speedup = scenario_orig_time > 0 and scenario_orig_time / scenario_enh_time or 0
    local scenario_final_speedup = scenario_orig_time > 0 and scenario_orig_time / scenario_final_time or 0
    
    print(printf("Scenario totals:\t%.6f\t%.6f\t%.6f\t%.2fx\t\t%.2fx", 
                 scenario_orig_time, scenario_enh_time, scenario_final_time,
                 scenario_enh_speedup, scenario_final_speedup))
    print()
    
    overall_original_time = overall_original_time + scenario_orig_time
    overall_enhanced_time = overall_enhanced_time + scenario_enh_time
    overall_final_time = overall_final_time + scenario_final_time
end

-- Tensor shape analysis benchmark
print("=== Realistic Tensor Shape Analysis Benchmark ===")
local tensor_configs = {
    {name = "CNN Input", shape = {32, 3, 224, 224}},
    {name = "Feature Map", shape = {32, 64, 112, 112}},
    {name = "Deep Feature", shape = {32, 256, 28, 28}},
    {name = "Dense Input", shape = {128, 512}},
    {name = "Attention", shape = {8, 512, 64}},
    {name = "Transformer", shape = {16, 1024, 768}},
    {name = "Vision Large", shape = {8, 768, 14, 14}},
    {name = "ResNet Block", shape = {64, 256, 56, 56}}
}

print("Config\t\t\tOriginal\tEnhanced\tFinal\t\tSpeedup(E)\tSpeedup(F)")
print("------\t\t\t--------\t--------\t-----\t\t----------\t----------")

local tensor_orig_time = 0
local tensor_enh_time = 0
local tensor_final_time = 0

for _, config in ipairs(tensor_configs) do
    -- Original: sequential factorization
    local orig_start = os.clock()
    for _, dim in ipairs(config.shape) do
        P9MLUtils.primeFactorize(dim)
    end
    local orig_end = os.clock()
    local orig_time = orig_end - orig_start
    
    -- Enhanced: batch processing
    local enh_start = os.clock()
    P9MLEnhancedUtils.batchPrimeFactorize(config.shape)
    local enh_end = os.clock()
    local enh_time = enh_end - enh_start
    
    -- Final: smart batch processing
    local final_start = os.clock()
    P9MLFinalUtils.batchSmartFactorize(config.shape)
    local final_end = os.clock()
    local final_time = final_end - final_start
    
    local enh_speedup = orig_time > 0 and orig_time / enh_time or 0
    local final_speedup = orig_time > 0 and orig_time / final_time or 0
    
    print(printf("%-20s\t%.6f\t%.6f\t%.6f\t%.2fx\t\t%.2fx", 
                 config.name, orig_time, enh_time, final_time, enh_speedup, final_speedup))
    
    tensor_orig_time = tensor_orig_time + orig_time
    tensor_enh_time = tensor_enh_time + enh_time
    tensor_final_time = tensor_final_time + final_time
end

local tensor_enh_speedup = tensor_orig_time > 0 and tensor_orig_time / tensor_enh_time or 0
local tensor_final_speedup = tensor_orig_time > 0 and tensor_orig_time / tensor_final_time or 0

print(printf("Tensor totals:\t\t%.6f\t%.6f\t%.6f\t%.2fx\t\t%.2fx", 
             tensor_orig_time, tensor_enh_time, tensor_final_time,
             tensor_enh_speedup, tensor_final_speedup))
print()

-- Overall performance summary
local overall_enh_speedup = overall_original_time > 0 and overall_original_time / overall_enhanced_time or 0
local overall_final_speedup = overall_original_time > 0 and overall_original_time / overall_final_time or 0

print("=== OVERALL PERFORMANCE SUMMARY ===")
print(printf("Total tests: %d", total_tests))
print(printf("Original total time: %.6f seconds", overall_original_time))
print(printf("Enhanced total time: %.6f seconds", overall_enhanced_time))
print(printf("Final total time: %.6f seconds", overall_final_time))
print(printf("Enhanced speedup: %.2fx", overall_enh_speedup))
print(printf("Final speedup: %.2fx", overall_final_speedup))
print()

-- Performance statistics from final implementation
local stats = P9MLFinalUtils.getPerformanceStats()
print("=== FINAL IMPLEMENTATION STATISTICS ===")
print(printf("Cache hits: %d", stats.cache_hits))
print(printf("Cache misses: %d", stats.cache_misses))
print(printf("Hit ratio: %.1f%%", stats.hit_ratio))
print()

-- SUCCESS CRITERIA CHECK
print("=== SUCCESS CRITERIA EVALUATION ===")
print("Target: 3-5x speed improvement for tensor shape analysis")
print()

if overall_final_speedup >= 3.0 then
    print(string.format("✓ SUCCESS: %.2fx overall speedup achieved", overall_final_speedup))
    if overall_final_speedup >= 5.0 then
        print("✓ EXCELLENT: Exceeded 5x target!")
    end
else
    print(string.format("⚠ PARTIAL: %.2fx overall speedup (target: 3-5x)", overall_final_speedup))
end

if tensor_final_speedup >= 3.0 then
    print(string.format("✓ SUCCESS: %.2fx tensor analysis speedup achieved", tensor_final_speedup))
    if tensor_final_speedup >= 5.0 then
        print("✓ EXCELLENT: Exceeded 5x tensor analysis target!")
    end
else
    print(string.format("⚠ PARTIAL: %.2fx tensor analysis speedup (target: 3-5x)", tensor_final_speedup))
end