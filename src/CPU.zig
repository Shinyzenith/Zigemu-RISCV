// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/CPU.zig
//
// Created by:	Aakash Sen Sharma, August 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

const Self = @This();

const Bus = @import("Bus.zig");
const DRAM = @import("DRAM.zig");

registers: [32]u64, // 64-bit CPU with 32 registers.
program_counter: u64,

bus: Bus, // CPU connected to Bus

pub fn reset(self: *Self) void {
    self.registers[0] = 0x00; // 0x0 is hardwired to 0.
    self.registers[2] = DRAM.memory_size + DRAM.memory_base_addr_offset; // Stack pointer resides at 0x02
    self.program_counter = DRAM.memory_base_addr_offset; // Set program counter to base addr

    self.bus.dram.reset();
}

pub fn fetch(self: *Self, comptime T: type) T {
    const inst = self.bus.fetch(T, self.program_counter);
    self.program_counter += @sizeOf(T);

    return inst;
}

/// Peek into an instructions of size @sizeOf(T) bit ahead without incrementing function pointer.
pub fn peek(self: *Self, comptime T: type) T {
    return self.bus.fetch(T, self.program_counter);
}

pub fn exec(self: *Self, inst: u32) i32 {
    _ = inst;
    _ = self;
}

pub fn dump_registers(self: *Self) void {
    _ = self;
}
