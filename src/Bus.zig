// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/Bus.zig
//
// Created by:	Aakash Sen Sharma, August 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

const Self = @This();

const DRAM = @import("./DRAM.zig");

dram: DRAM,

pub fn fetch(self: *Self, comptime T: type, address: u64) T {
    check_addr_underflow(address);
    return self.dram.fetch(T, address);
}

pub fn store(self: *Self, comptime T: type, address: u64, value: T) void {
    check_addr_underflow(address);
    self.dram.store(T, address, value);
}

fn check_addr_underflow(address: u64) void {
    if (address < DRAM.memory_base_addr_offset) {
        @panic("Supplied address seeps into memory mapped I/O region");
    }
}
