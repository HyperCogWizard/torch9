#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "p9ml_prime_factorization.c"

// Lua wrapper for the optimized prime factorization
static int lua_prime_factorize_optimized(lua_State *L) {
    uint32_t n = (uint32_t)luaL_checknumber(L, 1);
    uint32_t factors[MAX_FACTORS];
    
    int count = prime_factorize_optimized(n, factors);
    
    // Create Lua table for results
    lua_createtable(L, count, 0);
    for (int i = 0; i < count; i++) {
        lua_pushnumber(L, factors[i]);
        lua_rawseti(L, -2, i + 1);
    }
    
    return 1;
}

// Lua wrapper for batch factorization
static int lua_batch_prime_factorize(lua_State *L) {
    luaL_checktype(L, 1, LUA_TTABLE);
    
    int n = lua_objlen(L, 1);
    uint32_t numbers[n];
    
    // Extract numbers from Lua table
    for (int i = 0; i < n; i++) {
        lua_rawgeti(L, 1, i + 1);
        numbers[i] = (uint32_t)lua_tonumber(L, -1);
        lua_pop(L, 1);
    }
    
    // Create result table
    lua_createtable(L, n, 0);
    
    // Process each number
    for (int i = 0; i < n; i++) {
        uint32_t factors[MAX_FACTORS];
        int count = prime_factorize_optimized(numbers[i], factors);
        
        // Create subtable for this number's factors
        lua_createtable(L, count, 0);
        for (int j = 0; j < count; j++) {
            lua_pushnumber(L, factors[j]);
            lua_rawseti(L, -2, j + 1);
        }
        lua_rawseti(L, -2, i + 1);
    }
    
    return 1;
}

// Lua wrapper for precomputing common dimensions
static int lua_precompute_common_dimensions(lua_State *L) {
    precompute_common_dimensions();
    lua_pushnumber(L, cache_size);
    return 1;
}

// Lua wrapper for cache stats
static int lua_get_cache_stats(lua_State *L) {
    int size, max_size;
    get_cache_stats(&size, &max_size);
    
    lua_createtable(L, 0, 2);
    lua_pushnumber(L, size);
    lua_setfield(L, -2, "size");
    lua_pushnumber(L, max_size);
    lua_setfield(L, -2, "max_size");
    
    return 1;
}

// Lua wrapper for clearing cache
static int lua_clear_cache(lua_State *L) {
    clear_factorization_cache();
    return 0;
}

// Module registration
static const struct luaL_Reg p9ml_prime_lib[] = {
    {"factorize", lua_prime_factorize_optimized},
    {"batch_factorize", lua_batch_prime_factorize},
    {"precompute_common", lua_precompute_common_dimensions},
    {"get_cache_stats", lua_get_cache_stats},
    {"clear_cache", lua_clear_cache},
    {NULL, NULL}
};

// Module initialization
int luaopen_p9ml_prime(lua_State *L) {
    luaL_register(L, "p9ml_prime", p9ml_prime_lib);
    
    // Initialize with common dimensions
    precompute_common_dimensions();
    
    return 1;
}