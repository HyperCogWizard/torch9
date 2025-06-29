#!/usr/bin/env lua5.3

-- Test runner for P9ML components
local P9MLTest = require('P9MLTest')

-- Initialize and run tests
local test_suite = P9MLTest
test_suite:init()

-- Run all tests
local success = test_suite:runAll()

-- Exit with appropriate code
os.exit(success and 0 or 1)