-- P9ML Utilities - Prime factorization and tensor shape analysis
-- Part of the P9ML Membrane Computing integration with Torch Neural Substrate

local P9MLUtils = {}

-- Prime factorization for tensor dimensions
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

-- Generate lexeme from tensor shape
function P9MLUtils.tensorToLexeme(tensor)
    if not torch or not torch.isTensor or not torch.isTensor(tensor) then
        return {}
    end
    
    local shape = tensor:size():totable()
    local lexeme = {
        shape = shape,
        prime_factors = {},
        dimensional_signature = {}
    }
    
    for i, dim in ipairs(shape) do
        lexeme.prime_factors[i] = P9MLUtils.primeFactorize(dim)
        lexeme.dimensional_signature[i] = table.concat(lexeme.prime_factors[i], "*")
    end
    
    lexeme.gestalt_signature = table.concat(lexeme.dimensional_signature, "x")
    return lexeme
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