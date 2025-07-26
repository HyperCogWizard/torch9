#!/usr/bin/env lua5.1

-- Benchmark script for prime factorization performance
local P9MLUtils = require('P9MLUtils')

-- Helper function to measure execution time
function measure_time(func, ...)
    local start_time = os.clock()
    local result = func(...)
    local end_time = os.clock()
    return result, (end_time - start_time)
end

-- Test numbers of various sizes
local test_numbers = {
    12, 60, 120, 1000, 2520, 9240, 27720, 110880, 498960, 1441440,
    100007, 1000003, 10000019, 100000007  -- Include some primes
}

print("=== Prime Factorization Benchmark ===")
print("Number\t\tFactors\t\t\t\tTime (seconds)")
print("------\t\t-------\t\t\t\t-------------")

local total_time = 0
local total_tests = 0

for _, num in ipairs(test_numbers) do
    local factors, elapsed = measure_time(P9MLUtils.primeFactorize, num)
    local factors_str = table.concat(factors, "*")
    if #factors_str > 30 then
        factors_str = factors_str:sub(1, 27) .. "..."
    end
    
    printf = string.format
    print(printf("%-12d\t%-30s\t%.6f", num, factors_str, elapsed))
    
    total_time = total_time + elapsed
    total_tests = total_tests + 1
end

print("\n=== Summary ===")
print(string.format("Total tests: %d", total_tests))
print(string.format("Total time: %.6f seconds", total_time))
print(string.format("Average time per test: %.6f seconds", total_time / total_tests))

-- Test with tensor-like scenarios (batches of factorizations)
print("\n=== Tensor Shape Analysis Simulation ===")
local tensor_dims = {
    {2, 3, 224, 224},  -- Common CNN input
    {1, 512, 7, 7},    -- Feature map
    {64, 256, 14, 14}, -- Another feature map
    {32, 3, 256, 256}, -- High-res input
    {16, 1024, 4, 4}   -- Deep feature map
}

local total_batch_time = 0
for i, dims in ipairs(tensor_dims) do
    local batch_start = os.clock()
    for _, dim in ipairs(dims) do
        P9MLUtils.primeFactorize(dim)
    end
    local batch_end = os.clock()
    local batch_time = batch_end - batch_start
    
    print(string.format("Tensor shape %s: %.6f seconds", 
                       table.concat(dims, "x"), batch_time))
    total_batch_time = total_batch_time + batch_time
end

print(string.format("\nTotal tensor analysis time: %.6f seconds", total_batch_time))
print(string.format("Average per tensor: %.6f seconds", total_batch_time / #tensor_dims))