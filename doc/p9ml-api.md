# P9ML API Reference

## Overview

The P9ML (P9 Membrane Layer) API provides a comprehensive interface for cognitive computing with membrane-wrapped neural modules. This document covers all public functions, classes, and configuration options.

## Table of Contents

- [Core API](#core-api)
- [Membrane Classes](#membrane-classes)
- [Cognitive Kernel](#cognitive-kernel)
- [Namespace Operations](#namespace-operations)
- [Configuration Options](#configuration-options)
- [Utility Functions](#utility-functions)

## Core API

### P9ML.init(config)

Initialize the P9ML system with optional configuration.

**Parameters:**
- `config` (table, optional): Configuration options

**Returns:**
- `P9ML`: The initialized P9ML system

**Example:**
```lua
local P9ML = require('P9ML')
P9ML.init({
    default_quantization = 0.9,
    similarity_threshold = 0.3,
    gestalt_update_interval = 10
})
```

### P9ML.wrapModule(module, config)

Wrap a neural module with P9ML membrane computing capabilities.

**Parameters:**
- `module`: Base neural module to wrap
- `config` (table, optional): Membrane-specific configuration

**Returns:**
- `P9MLMembrane`: Wrapped membrane object

**Example:**
```lua
local linear = nn.Linear(784, 128)
local membrane = P9ML.wrapModule(linear, {
    initial_quantization = 0.8,
    adaptation_rate = 0.02
})
```

### P9ML.Linear(inputSize, outputSize, config)

Create a linear layer wrapped in a P9ML membrane.

**Parameters:**
- `inputSize` (number): Input dimension size
- `outputSize` (number): Output dimension size  
- `config` (table, optional): Configuration options

**Returns:**
- `P9MLMembrane`: Linear membrane wrapper

**Example:**
```lua
local linear = P9ML.Linear(784, 128, {
    initial_quantization = 0.9,
    gradient_decay = 0.98
})
```

### P9ML.Conv2d(inputChannels, outputChannels, kernelSize, config)

Create a 2D convolutional layer wrapped in a P9ML membrane.

**Parameters:**
- `inputChannels` (number): Number of input channels
- `outputChannels` (number): Number of output channels
- `kernelSize` (number): Convolution kernel size
- `config` (table, optional): Configuration options

**Returns:**
- `P9MLMembrane`: Convolutional membrane wrapper

**Example:**
```lua
local conv = P9ML.Conv2d(3, 64, 3, {
    initial_quantization = 0.85,
    adaptation_rate = 0.015
})
```

### P9ML.status()

Get comprehensive system status information.

**Returns:**
- `table`: System status with membrane, gestalt, and cognitive information

**Example:**
```lua
local status = P9ML.status()
print("Total membranes:", status.membranes.total)
print("Gestalt coherence:", status.gestalt.coherence)
print("Cognitive clusters:", status.cognitive.clusters)
```

### P9ML.synthesize()

Trigger gestalt tensor field synthesis from current membrane activities.

**Returns:**
- `table`: Gestalt field with components, energy, and coherence metrics

**Example:**
```lua
local gestalt_field = P9ML.synthesize()
print("Field energy:", gestalt_field.field_energy)
print("Components:", #gestalt_field.components)
```

### P9ML.getMembranes()

Get list of all registered membranes.

**Returns:**
- `table`: Array of all P9MLMembrane objects

### P9ML.getCognitiveSimilarity(membrane1, membrane2)

Compute cognitive similarity between two membranes.

**Parameters:**
- `membrane1` (P9MLMembrane): First membrane
- `membrane2` (P9MLMembrane): Second membrane

**Returns:**
- `number`: Similarity score between 0.0 and 1.0

## Membrane Classes

### P9MLMembrane

Core membrane wrapper class that provides cognitive computing capabilities.

#### Methods

##### :forward(input)

Perform forward pass through the membrane.

**Parameters:**
- `input`: Input tensor

**Returns:**
- Output tensor after membrane processing

**Example:**
```lua
local output = membrane:forward(input_tensor)
```

##### :backward(gradOutput)

Perform backward pass through the membrane.

**Parameters:**
- `gradOutput`: Gradient tensor from downstream

**Returns:**
- Gradient tensor for upstream propagation

##### :getId()

Get unique membrane identifier.

**Returns:**
- `string`: Unique membrane ID

##### :getLexeme()

Get current cognitive lexeme/signature.

**Returns:**
- `table`: Lexeme with gestalt signature and dimensional information

**Example:**
```lua
local lexeme = membrane:getLexeme()
print("Signature:", lexeme.gestalt_signature)
print("Factors:", table.concat(lexeme.dimensional_signature, " | "))
```

##### :getEvolutionState()

Get current evolution state and parameters.

**Returns:**
- `table`: Evolution state with generation, fitness, and quantization info

**Example:**
```lua
local evolution = membrane:getEvolutionState()
print("Generation:", evolution.generation)
print("Fitness:", evolution.fitness)
print("Quantization:", evolution.quantization_level)
```

##### :getActivityLevel()

Get current membrane activity level.

**Returns:**
- `number`: Activity level between 0.0 and 1.0

##### :connectTo(targetMembrane)

Create connection to another membrane.

**Parameters:**
- `targetMembrane` (P9MLMembrane): Target membrane to connect to

**Example:**
```lua
membrane1:connectTo(membrane2)
```

##### :getConnections()

Get list of connected membranes.

**Returns:**
- `table`: Array of connected membrane objects

## Cognitive Kernel

### P9MLCognitiveKernel

Manages hypergraph topology and cognitive grammar.

#### Methods

##### :encodeTensorShape(shape, nodeId)

Encode tensor shape into cognitive representation.

**Parameters:**
- `shape` (table): Array of dimension sizes
- `nodeId` (string): Node identifier

**Example:**
```lua
P9ML.cognitive_kernel:encodeTensorShape({2, 3, 4}, "membrane_001")
```

##### :getHypergraphTopology()

Get current hypergraph structure.

**Returns:**
- `table`: Hypergraph with nodes and edges

##### :getCognitiveClusters()

Get current cognitive clusters.

**Returns:**
- `table`: Array of cluster information

##### :addGrammarRule(name, rule)

Add custom cognitive grammar rule.

**Parameters:**
- `name` (string): Rule identifier
- `rule` (table): Rule specification with pattern, weight, etc.

**Returns:**
- `boolean`: Success status

**Example:**
```lua
local success = P9ML.cognitive_kernel:addGrammarRule("custom", {
    pattern = "test_pattern",
    cognitive_weight = 1.0,
    interaction_range = 0.2
})
```

##### :queryEncodingsByCategory(category)

Query tensor encodings by cognitive category.

**Parameters:**
- `category` (string): Category name (e.g., "tensor", "matrix", "vector")

**Returns:**
- `table`: Array of matching encodings

## Namespace Operations

### P9MLNamespace

Central registry and orchestration system.

#### Methods

##### :registerMembrane(membrane)

Register a membrane with the namespace.

**Parameters:**
- `membrane` (P9MLMembrane): Membrane to register

##### :findSimilarMembranes(membrane, threshold)

Find membranes similar to the given membrane.

**Parameters:**
- `membrane` (P9MLMembrane): Reference membrane
- `threshold` (number): Minimum similarity threshold

**Returns:**
- `table`: Array of similar membranes

##### :synthesizeGestaltField()

Synthesize gestalt tensor field from membrane activities.

**Returns:**
- `table`: Gestalt field structure

##### :getMetadata()

Get namespace registry metadata.

**Returns:**
- `table`: Metadata with counts, types, and timing information

##### :getGestaltState()

Get current gestalt state.

**Returns:**
- `table`: Gestalt state with coherence and synthesis information

##### :getComputationGraph()

Get computation graph structure.

**Returns:**
- `table`: Graph with nodes, edges, and topology hash

## Configuration Options

### System Configuration

```lua
config = {
    -- Global settings
    default_quantization = 0.9,        -- Default quantization level
    similarity_threshold = 0.3,        -- Minimum similarity for connections
    gestalt_update_interval = 10,      -- Updates between gestalt synthesis
    
    -- Performance settings
    max_membranes = 10000,             -- Maximum number of membranes
    cache_size = 1000,                 -- Cognitive signature cache size
    gc_interval = 100,                 -- Garbage collection interval
    
    -- Evolution settings
    evolution_enabled = true,          -- Enable membrane evolution
    meta_learning_enabled = true,      -- Enable meta-learning loops
    adaptation_global_rate = 0.01      -- Global adaptation rate modifier
}
```

### Membrane Configuration

```lua
membrane_config = {
    -- Evolution parameters
    initial_quantization = 0.9,       -- Starting quantization level
    gradient_decay = 0.99,             -- Gradient decay factor
    quantization_threshold = 0.1,      -- Minimum quantization threshold
    adaptation_rate = 0.01,            -- Rate of adaptation
    fitness_momentum = 0.9,            -- Fitness smoothing factor
    
    -- Cognitive parameters
    signature_update_rate = 1.0,       -- How often to update signatures
    activity_decay = 0.95,             -- Activity level decay
    connection_threshold = 0.5,        -- Minimum similarity for connections
    
    -- Performance parameters
    quantization_enabled = true,       -- Enable quantization adaptation
    evolution_enabled = true,          -- Enable evolution rules
    caching_enabled = true             -- Enable signature caching
}
```

## Utility Functions

### P9MLUtils

Collection of utility functions for the P9ML system.

#### generateMembraneId()

Generate unique membrane identifier.

**Returns:**
- `string`: Unique ID string

#### tensorToLexeme(tensor)

Convert tensor to cognitive lexeme.

**Parameters:**
- `tensor`: Input tensor

**Returns:**
- `table`: Lexeme structure

#### computePrimeFactorization(number)

Compute prime factorization of a number.

**Parameters:**
- `number` (number): Number to factorize

**Returns:**
- `table`: Array of prime factors

#### formatCognitiveSignature(factors)

Format prime factors into cognitive signature string.

**Parameters:**
- `factors` (table): Array of factor arrays

**Returns:**
- `string`: Formatted signature

#### computeSimilarity(sig1, sig2)

Compute similarity between cognitive signatures.

**Parameters:**
- `sig1` (string): First signature
- `sig2` (string): Second signature

**Returns:**
- `number`: Similarity score 0.0-1.0

## Error Handling

### Common Errors

#### MembraneNotInitialized
Thrown when attempting to use membrane before P9ML system initialization.

```lua
-- Fix: Initialize system first
P9ML.init()
```

#### InvalidTensorShape
Thrown when tensor shape cannot be processed.

```lua
-- Fix: Ensure tensor has valid dimensions
assert(tensor:nDimension() > 0, "Tensor must have dimensions")
```

#### CognitiveKernelError
Thrown when cognitive kernel operations fail.

```lua
-- Fix: Check that cognitive kernel is properly initialized
assert(P9ML.cognitive_kernel ~= nil, "Cognitive kernel not initialized")
```

### Debugging

#### Enable Debug Mode

```lua
P9ML.init({
    debug_mode = true,
    verbose_logging = true,
    trace_evolution = true
})
```

#### Debug Information

```lua
-- Get detailed system state
local debug_info = P9ML.getDebugInfo()
print("Memory usage:", debug_info.memory_usage)
print("Active computations:", debug_info.active_computations)
print("Performance metrics:", debug_info.performance)
```

## Performance Tips

### Optimization Guidelines

1. **Batch Processing**: Process multiple inputs together when possible
2. **Cache Management**: Configure appropriate cache sizes for your workload
3. **Similarity Thresholds**: Tune thresholds to balance accuracy vs performance
4. **Evolution Settings**: Adjust evolution rates based on problem complexity
5. **Memory Management**: Monitor memory usage with large numbers of membranes

### Memory Optimization

```lua
-- Configure for memory efficiency
P9ML.init({
    cache_size = 500,                  -- Smaller cache
    max_membranes = 1000,              -- Limit membrane count
    gc_interval = 50,                  -- More frequent GC
    gestalt_update_interval = 20       -- Less frequent gestalt updates
})
```

### Performance Monitoring

```lua
-- Monitor performance metrics
local metrics = P9ML.getPerformanceMetrics()
print("Average forward time:", metrics.avg_forward_time)
print("Memory usage:", metrics.memory_usage)
print("Cache hit rate:", metrics.cache_hit_rate)
```

---

This API reference provides comprehensive documentation for all P9ML functionality. For examples and tutorials, see the main documentation and example files.