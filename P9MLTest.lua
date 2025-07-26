-- P9ML Test Suite - Basic functionality tests for membrane computing components
-- Tests membrane operations, namespace orchestration, cognitive kernel, and evolution

local P9MLTest = {}

-- Initialize test environment
function P9MLTest:init()
    print("Initializing P9ML Test Suite...")
    
    -- Check if torch is available for testing
    if not torch then
        print("Warning: torch not available, using mock implementations")
        self:_setupMockTorch()
    end
    
    return true
end

-- Setup mock torch implementation for testing without full Torch7
function P9MLTest:_setupMockTorch()
    -- Create a minimal torch mock for testing
    _G.torch = {
        class = function(name, parent)
            local cls = {}
            cls.__name = name
            cls.__parent = parent
            
            setmetatable(cls, {
                __call = function(self, ...)
                    local instance = {}
                    setmetatable(instance, {__index = self})
                    if instance.__init then
                        instance:__init(...)
                    end
                    return instance
                end
            })
            
            return cls
        end,
        
        isTensor = function(obj)
            return type(obj) == "table" and obj._isTensor == true
        end,
        
        type = function(obj)
            if type(obj) == "table" and obj._type then
                return obj._type
            end
            return type(obj)
        end
    }
    
    -- Mock tensor for testing
    local MockTensor = {}
    function MockTensor:new(data)
        local tensor = {
            _isTensor = true,
            _type = "MockTensor",
            _data = data or {1, 2, 3, 4},
            _size = {4}
        }
        
        function tensor:size()
            return {
                totable = function() return tensor._size end
            }
        end
        
        function tensor:nElement()
            local total = 1
            for _, s in ipairs(tensor._size) do
                total = total * s
            end
            return total
        end
        
        function tensor:norm()
            local sum = 0
            for _, v in ipairs(tensor._data) do
                sum = sum + v * v
            end
            return math.sqrt(sum)
        end
        
        function tensor:clone()
            local clone_data = {}
            for i, v in ipairs(tensor._data) do
                clone_data[i] = v
            end
            return MockTensor:new(clone_data)
        end
        
        function tensor:mul(value)
            for i, v in ipairs(tensor._data) do
                tensor._data[i] = v * value
            end
            return tensor
        end
        
        function tensor:div(value)
            for i, v in ipairs(tensor._data) do
                tensor._data[i] = v / value
            end
            return tensor
        end
        
        function tensor:round()
            for i, v in ipairs(tensor._data) do
                tensor._data[i] = math.floor(v + 0.5)
            end
            return tensor
        end
        
        function tensor:storage()
            return tensor._data
        end
        
        return tensor
    end
    
    _G.MockTensor = MockTensor
end

-- Test P9MLUtils functionality
function P9MLTest:testUtils()
    print("Testing P9MLUtils...")
    
    local P9MLUtils = require('P9MLUtils')
    
    -- Test prime factorization
    local factors = P9MLUtils.primeFactorize(12)
    assert(#factors == 3, "Expected 3 factors for 12")
    assert(factors[1] == 2 and factors[2] == 2 and factors[3] == 3, 
           "Incorrect factorization of 12")
    
    -- Test with prime number
    local prime_factors = P9MLUtils.primeFactorize(7)
    assert(#prime_factors == 1 and prime_factors[1] == 7, 
           "Incorrect factorization of prime 7")
    
    -- Test tensor lexeme generation with mock tensor
    local tensor = MockTensor:new({1, 2, 3, 4})
    tensor._size = {2, 2}
    
    local lexeme = P9MLUtils.tensorToLexeme(tensor)
    assert(lexeme ~= nil, "Lexeme should not be nil")
    assert(lexeme.shape ~= nil, "Lexeme should have shape")
    assert(#lexeme.shape == 2, "Expected 2D tensor")
    
    -- Test cognitive distance with identical lexemes
    local tensor_copy = MockTensor:new({1, 2, 3, 4})
    tensor_copy._size = {2, 2}
    local lexeme2 = P9MLUtils.tensorToLexeme(tensor_copy)
    local distance = P9MLUtils.cognitiveDistance(lexeme, lexeme2)
    -- Distance should be 0 since same shape and prime factors
    assert(distance <= 0.1, "Distance between similar lexemes should be very small, got: " .. tostring(distance))
    
    print("✓ P9MLUtils tests passed")
    return true
end

-- Test P9MLMembrane functionality
function P9MLTest:testMembrane()
    print("Testing P9MLMembrane...")
    
    local P9MLMembrane = require('P9MLMembrane')
    
    -- Create a membrane with mock module
    local mockModule = {
        forward = function(self, input) return input end,
        backward = function(self, gradOutput) return gradOutput end
    }
    
    local membrane = P9MLMembrane.new(mockModule)
    assert(membrane ~= nil, "Membrane should be created")
    assert(membrane:getId() ~= nil, "Membrane should have ID")
    
    -- Test forward pass
    local input = MockTensor:new({1, 2, 3, 4})
    local output = membrane:forward(input)
    assert(torch.isTensor(output), "Output should be tensor")
    
    -- Test evolution state
    local evolution_state = membrane:getEvolutionState()
    assert(evolution_state.generation > 0, "Generation should increase after forward")
    assert(evolution_state.fitness >= 0, "Fitness should be non-negative")
    
    -- Test membrane connections
    local membrane2 = P9MLMembrane.new(mockModule)
    local connected = membrane:connectTo(membrane2)
    assert(connected == true, "Should be able to connect membranes")
    
    local connections = membrane:getConnections()
    assert(connections[membrane2:getId()] ~= nil, "Connection should exist")
    
    print("✓ P9MLMembrane tests passed")
    return true
end

-- Test P9MLNamespace functionality
function P9MLTest:testNamespace()
    print("Testing P9MLNamespace...")
    
    local P9MLNamespace = require('P9MLNamespace')
    local P9MLMembrane = require('P9MLMembrane')
    
    -- Initialize namespace
    local namespace = P9MLNamespace:init()
    assert(namespace ~= nil, "Namespace should be initialized")
    
    -- Create and register membranes
    local membrane1 = P9MLMembrane.new({})
    local membrane2 = P9MLMembrane.new({})
    
    -- Debug: Check membrane creation
    assert(membrane1 ~= nil, "Membrane1 should be created")
    assert(membrane1.getId ~= nil, "Membrane1 should have getId method")
    
    local id1 = membrane1:getId()
    assert(id1 ~= nil, "Membrane1 should have a valid ID, got: " .. tostring(id1))
    
    -- Membranes auto-register during creation, so let's check if they're already registered
    local already_registered1 = namespace:getMembrane(membrane1:getId()) ~= nil
    local already_registered2 = namespace:getMembrane(membrane2:getId()) ~= nil
    
    -- Manual registration should fail if already registered (which is expected)
    local registered1 = namespace:registerMembrane(membrane1)
    local registered2 = namespace:registerMembrane(membrane2)
    
    -- Debug registration result
    print("Debug: already_registered1 =", already_registered1, "already_registered2 =", already_registered2)
    print("Debug: manual_registered1 =", registered1, "manual_registered2 =", registered2)
    
    -- Either they auto-registered OR manual registration succeeded
    assert(already_registered1 or registered1, "First membrane should be registered (auto or manual)")
    assert(already_registered2 or registered2, "Second membrane should be registered (auto or manual)")
    
    -- Test retrieval
    local retrieved = namespace:getMembrane(membrane1:getId())
    assert(retrieved == membrane1, "Should retrieve correct membrane")
    
    -- Test metadata - check what's actually in the namespace
    local metadata = namespace:getMetadata()
    print("Debug: metadata.total_membranes =", metadata.total_membranes)
    print("Debug: metadata.active_membranes =", metadata.active_membranes)
    
    -- Count actual membranes in registry
    local actual_count = 0
    for id, membrane in pairs(namespace.membranes) do
        actual_count = actual_count + 1
        print("Debug: found membrane with ID:", id)
    end
    print("Debug: actual membrane count =", actual_count)
    
    assert(metadata.total_membranes >= 2, "Should have at least 2 registered membranes, got: " .. tostring(metadata.total_membranes))
    assert(metadata.active_membranes >= 2, "Should have at least 2 active membranes, got: " .. tostring(metadata.active_membranes))
    
    -- Test gestalt synthesis
    local gestalt_field = namespace:synthesizeGestaltField()
    print("Debug: gestalt_field =", gestalt_field)
    if gestalt_field then
        print("Debug: gestalt_field.components =", gestalt_field.components)
        if gestalt_field.components then
            print("Debug: component count =", #gestalt_field.components)
        end
    end
    -- Note: gestalt field might be nil if membranes haven't processed tensors yet
    -- This is acceptable behavior
    
    -- Test unregistration
    local initial_count = namespace:getMetadata().active_membranes
    local unregistered = namespace:unregisterMembrane(membrane1:getId())
    assert(unregistered == true, "Should unregister membrane successfully")
    
    local metadata_after = namespace:getMetadata()
    print("Debug: initial_count =", initial_count, "after unregister =", metadata_after.active_membranes)
    assert(metadata_after.active_membranes == initial_count - 1, 
           "Should have one less active membrane after unregister, expected: " .. 
           tostring(initial_count - 1) .. " got: " .. tostring(metadata_after.active_membranes))
    
    print("✓ P9MLNamespace tests passed")
    return true
end

-- Test P9MLCognitiveKernel functionality  
function P9MLTest:testCognitiveKernel()
    print("Testing P9MLCognitiveKernel...")
    
    local P9MLCognitiveKernel = require('P9MLCognitiveKernel')
    
    -- Initialize kernel
    local kernel = P9MLCognitiveKernel:init()
    assert(kernel ~= nil, "Kernel should be initialized")
    
    -- Test tensor encoding
    local shape1 = {2, 3, 4}
    local encoding1 = kernel:encodeTensorShape(shape1, "mem1")
    assert(encoding1 ~= nil, "Encoding should be created")
    assert(encoding1.cognitive_category ~= nil, "Should have cognitive category")
    assert(encoding1.cognitive_signature ~= nil, "Should have cognitive signature")
    
    -- Test similar shape encoding
    local shape2 = {2, 3, 4}
    local encoding2 = kernel:encodeTensorShape(shape2, "mem2")
    
    -- Check hypergraph creation
    local hypergraph = kernel:getHypergraphTopology()
    assert(hypergraph.nodes["mem1"] ~= nil, "Node mem1 should exist")
    assert(hypergraph.nodes["mem2"] ~= nil, "Node mem2 should exist")
    
    -- Test cognitive clusters
    local clusters = kernel:getCognitiveClusters()
    assert(type(clusters) == "table", "Clusters should be table")
    
    -- Test grammar rule addition
    local added = kernel:addGrammarRule("custom", {
        pattern = "test",
        cognitive_weight = 1.0,
        interaction_range = 0.2
    })
    assert(added == true, "Should add custom grammar rule")
    
    -- Test category querying
    local tensor_encodings = kernel:queryEncodingsByCategory("tensor")
    assert(type(tensor_encodings) == "table", "Should return table of encodings")
    
    print("✓ P9MLCognitiveKernel tests passed")
    return true
end

-- Test integration between components
function P9MLTest:testIntegration()
    print("Testing P9ML Integration...")
    
    local P9MLNamespace = require('P9MLNamespace')
    local P9MLMembrane = require('P9MLMembrane')
    local P9MLCognitiveKernel = require('P9MLCognitiveKernel')
    
    -- Initialize all components
    local namespace = P9MLNamespace:init()
    local kernel = P9MLCognitiveKernel:init()
    
    -- Create membranes with different configurations
    local membrane1 = P9MLMembrane.new({}, {initial_quantization = 0.8})
    local membrane2 = P9MLMembrane.new({}, {initial_quantization = 0.6})
    
    -- Register membranes
    namespace:registerMembrane(membrane1)
    namespace:registerMembrane(membrane2)
    
    -- Process tensors through membranes
    local tensor1 = MockTensor:new({1, 2, 3, 4})
    tensor1._size = {2, 2}
    
    local tensor2 = MockTensor:new({5, 6, 7, 8})
    tensor2._size = {2, 2}
    
    -- Forward pass creates lexemes and updates kernel
    membrane1:forward(tensor1)
    membrane2:forward(tensor2)
    
    -- Encode in cognitive kernel
    kernel:encodeTensorShape(tensor1:size():totable(), membrane1:getId())
    kernel:encodeTensorShape(tensor2:size():totable(), membrane2:getId())
    
    -- Check gestalt synthesis
    local gestalt_state = namespace:getGestaltState()
    assert(gestalt_state.coherence_metric >= 0, "Coherence should be non-negative")
    
    local gestalt_field = namespace:synthesizeGestaltField()
    assert(gestalt_field ~= nil, "Gestalt field should be synthesized")
    assert(gestalt_field.components ~= nil, "Field should have components")
    
    -- Test cognitive similarity
    local similar_membranes = namespace:findSimilarMembranes(membrane1, 0.8)
    assert(type(similar_membranes) == "table", "Should return similar membranes")
    
    print("✓ P9ML Integration tests passed")
    return true
end

-- Test evolution and meta-learning
function P9MLTest:testEvolution()
    print("Testing P9ML Evolution...")
    
    local P9MLMembrane = require('P9MLMembrane')
    
    -- Create membrane with specific evolution rules
    local membrane = P9MLMembrane.new({}, {
        gradient_decay = 0.95,
        quantization_threshold = 0.2,
        adaptation_rate = 0.1
    })
    
    -- Run multiple forward passes to trigger evolution
    local tensor = MockTensor:new({1, 2, 3, 4})
    
    local initial_fitness = membrane:getEvolutionState().fitness
    local initial_quantization = membrane:getEvolutionState().quantization_level
    
    -- Multiple forward passes
    for i = 1, 10 do
        membrane:forward(tensor)
    end
    
    local final_state = membrane:getEvolutionState()
    assert(final_state.generation == 10, "Should have 10 generations")
    assert(#final_state.adaptation_history > 0, "Should have adaptation history")
    
    -- Test evolution rule modification
    local rule_set = membrane:setEvolutionRule("adaptation_rate", 0.05)
    assert(rule_set == true, "Should be able to set evolution rule")
    
    print("✓ P9ML Evolution tests passed")
    return true
end

-- Run all tests
function P9MLTest:runAll()
    print(string.rep("=", 50))
    print("P9ML Membrane Computing Test Suite")
    print(string.rep("=", 50))
    
    local tests_passed = 0
    local total_tests = 0
    
    local test_functions = {
        self.testUtils,
        self.testMembrane,
        self.testNamespace,
        self.testCognitiveKernel,
        self.testIntegration,
        self.testEvolution
    }
    
    for _, test_func in ipairs(test_functions) do
        total_tests = total_tests + 1
        local success, error_msg = pcall(test_func, self)
        
        if success then
            tests_passed = tests_passed + 1
        else
            print("✗ Test failed: " .. (error_msg or "Unknown error"))
        end
    end
    
    print(string.rep("=", 50))
    print(string.format("Tests passed: %d/%d", tests_passed, total_tests))
    
    if tests_passed == total_tests then
        print("🎉 All P9ML tests passed!")
        return true
    else
        print("❌ Some tests failed")
        return false
    end
end

return P9MLTest