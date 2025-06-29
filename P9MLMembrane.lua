-- P9ML Membrane - Core membrane wrapper for Torch neural modules
-- Implements membrane computing paradigm with quantization and evolution interfaces

local P9MLUtils = require('P9MLUtils')

local P9MLMembrane = {}
P9MLMembrane.__index = P9MLMembrane

-- Constructor
function P9MLMembrane.new(baseModule, config)
    local self = setmetatable({}, P9MLMembrane)
    self:__init(baseModule, config)
    return self
end

function P9MLMembrane:__init(baseModule, config)
    self.id = P9MLUtils.generateMembraneId()
    self.baseModule = baseModule
    self.config = config or {}
    
    -- Membrane state
    self.lexeme = nil
    self.evolution_state = {
        generation = 0,
        fitness = 0.0,
        adaptation_history = {},
        quantization_level = self.config.initial_quantization or 1.0
    }
    
    -- Cognitive properties
    self.cognitive_signature = ""
    self.activity_level = 0.0
    self.connections = {}
    self.membrane_type = (torch and torch.type and torch.type(baseModule)) or type(baseModule) or "unknown"
    
    -- Evolution parameters
    self.evolution_rules = {
        gradient_decay = self.config.gradient_decay or 0.99,
        quantization_threshold = self.config.quantization_threshold or 0.1,
        adaptation_rate = self.config.adaptation_rate or 0.01,
        fitness_momentum = self.config.fitness_momentum or 0.9
    }
    
    -- Initialize membrane properties
    self:_initializeMembrane()
end

function P9MLMembrane:_initializeMembrane()
    -- Register with namespace if available
    if _G.P9MLNamespace and _G.P9MLNamespace.registerMembrane then
        _G.P9MLNamespace:registerMembrane(self)
    end
    
    -- Set initial cognitive signature
    self:_updateCognitiveSignature()
end

function P9MLMembrane:forward(input)
    -- Update lexeme based on input tensor
    if torch and torch.isTensor and torch.isTensor(input) then
        self.lexeme = P9MLUtils.tensorToLexeme(input)
        self:_updateCognitiveSignature()
    end
    
    -- Forward pass through base module
    local output
    if self.baseModule and self.baseModule.forward then
        output = self.baseModule:forward(input)
    else
        -- Identity operation if no base module
        output = input
    end
    
    -- Apply quantization if needed
    if self.evolution_state.quantization_level < 1.0 then
        output = self:_applyQuantization(output)
    end
    
    -- Update activity level
    self:_updateActivity(input, output)
    
    -- Evolve membrane state
    self:_evolveState(input, output)
    
    return output
end

function P9MLMembrane:backward(gradOutput)
    if self.baseModule and self.baseModule.backward then
        local gradInput = self.baseModule:backward(gradOutput)
        
        -- Apply evolution to gradients
        gradInput = self:_evolveGradients(gradInput)
        
        return gradInput
    end
    
    return gradOutput
end

function P9MLMembrane:_applyQuantization(tensor)
    if not torch or not torch.isTensor or not torch.isTensor(tensor) then
        return tensor
    end
    
    local q_level = self.evolution_state.quantization_level
    if q_level >= 1.0 then
        return tensor
    end
    
    -- Simple quantization scheme
    local quantized = tensor:clone()
    local scale = 1.0 / q_level
    quantized:div(scale):round():mul(scale)
    
    return quantized
end

function P9MLMembrane:_updateActivity(input, output)
    local input_norm = (torch and torch.isTensor and torch.isTensor(input)) and input:norm() or 0
    local output_norm = (torch and torch.isTensor and torch.isTensor(output)) and output:norm() or 0
    
    -- Compute activity as normalized energy transfer
    local activity = (input_norm + output_norm) / 2.0
    
    -- Exponential moving average
    local momentum = 0.9
    self.activity_level = momentum * self.activity_level + (1 - momentum) * activity
end

function P9MLMembrane:_updateCognitiveSignature()
    if self.lexeme then
        self.cognitive_signature = self.lexeme.gestalt_signature or ""
    else
        self.cognitive_signature = self.membrane_type .. "_" .. self.id
    end
end

function P9MLMembrane:_evolveState(input, output)
    self.evolution_state.generation = self.evolution_state.generation + 1
    
    -- Compute fitness based on activity and stability
    local current_fitness = self.activity_level * (1.0 - self:_computeInstability(input, output))
    
    -- Update fitness with momentum
    local momentum = self.evolution_rules.fitness_momentum
    self.evolution_state.fitness = momentum * self.evolution_state.fitness + 
                                   (1 - momentum) * current_fitness
    
    -- Adapt quantization level based on fitness
    local adaptation = self.evolution_rules.adaptation_rate * 
                       (self.evolution_state.fitness - 0.5) -- Center around 0.5
    
    self.evolution_state.quantization_level = math.max(0.1, 
        math.min(1.0, self.evolution_state.quantization_level + adaptation))
    
    -- Record adaptation history
    table.insert(self.evolution_state.adaptation_history, {
        generation = self.evolution_state.generation,
        fitness = self.evolution_state.fitness,
        quantization = self.evolution_state.quantization_level,
        activity = self.activity_level
    })
    
    -- Keep only recent history
    if #self.evolution_state.adaptation_history > 100 then
        table.remove(self.evolution_state.adaptation_history, 1)
    end
end

function P9MLMembrane:_computeInstability(input, output)
    -- Simple instability measure based on norm changes
    if not torch or not torch.isTensor or not torch.isTensor(input) or not torch.isTensor(output) then
        return 0.0
    end
    
    local input_norm = input:norm()
    local output_norm = output:norm()
    
    if input_norm == 0 then
        return output_norm > 0 and 1.0 or 0.0
    end
    
    return math.abs(output_norm - input_norm) / input_norm
end

function P9MLMembrane:_evolveGradients(gradInput)
    if not torch or not torch.isTensor or not torch.isTensor(gradInput) then
        return gradInput
    end
    
    -- Apply gradient decay evolution rule
    local decay = self.evolution_rules.gradient_decay
    return gradInput:mul(decay)
end

-- Membrane interface methods
function P9MLMembrane:getId()
    return self.id
end

function P9MLMembrane:getLexeme()
    return self.lexeme
end

function P9MLMembrane:getCognitiveSignature()
    return self.cognitive_signature
end

function P9MLMembrane:getEvolutionState()
    return self.evolution_state
end

function P9MLMembrane:getActivityLevel()
    return self.activity_level
end

function P9MLMembrane:connectTo(other_membrane)
    if not other_membrane or not other_membrane.getId then
        return false
    end
    
    local other_id = other_membrane:getId()
    self.connections[other_id] = {
        membrane = other_membrane,
        strength = 1.0,
        established = os.time()
    }
    
    return true
end

function P9MLMembrane:getConnections()
    return self.connections
end

function P9MLMembrane:setEvolutionRule(rule_name, value)
    if self.evolution_rules[rule_name] ~= nil then
        self.evolution_rules[rule_name] = value
        return true
    end
    return false
end

return P9MLMembrane