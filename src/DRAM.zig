// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/DRAM.zig
//
// Created by:	Aakash Sen Sharma, August 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

const Self = @This();
const std = @import("std");
const fmt = std.fmt;

pub const memory_size: usize = 1024 * 1024 * 1; // 1 MiB of memory
pub const memory_base_addr_offset = 0x800000000; // Since RISC-V uses memory mapped IO, the lower ranges are used by I/O.

memory: [memory_size]u8 = undefined,

pub fn reset(self: *Self) void {
    @memset(&self.memory, 1);
}

pub fn fetch(self: *Self, comptime T: type, address: u64) T {
    switch (T) {
        u8, u16, u32, u64 => {},
        else => {
            @compileError(fmt.comptimePrint("Type {s} not implemented for DRAM::fetch", .{@typeName(T)}));
        },
    }

    var addr: T = self.memory[address - memory_base_addr_offset];

    // TODO: Can this sort of chaining be done better?
    if (T == u16 or T == u16 or T == u32 or T == u64) {
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 1]) << 8;
    }

    if (T == u32 or T == u64) {
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 2]) << 16;
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 3]) << 24;
    }

    if (T == u64) {
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 4]) << 32;
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 5]) << 40;
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 6]) << 48;
        addr |= @as(T, self.memory[address - memory_base_addr_offset + 7]) << 56;
    }

    return addr;
}

pub fn store(self: *Self, comptime T: type, address: u64, value: T) void {
    switch (T) {
        u8, u16, u32, u64 => {},
        else => {
            @compileError(fmt.comptimePrint("Type {s} not implemented for DRAM::store", .{@typeName(T)}));
        },
    }

    self.memory[address - memory_base_addr_offset] = @intCast(value & 0xff);

    if (T == u16 or T == u32 or T == u64) {
        self.memory[address - memory_base_addr_offset + 1] = @intCast((value >> 8) & 0xff);
    }

    if (T == u32 or T == u64) {
        self.memory[address - memory_base_addr_offset + 2] = @intCast((value >> 16) & 0xff);
        self.memory[address - memory_base_addr_offset + 3] = @intCast((value >> 24) & 0xff);
    }

    if (T == u64) {
        self.memory[address - memory_base_addr_offset + 4] = @intCast((value >> 32) & 0xff);
        self.memory[address - memory_base_addr_offset + 5] = @intCast((value >> 40) & 0xff);
        self.memory[address - memory_base_addr_offset + 6] = @intCast((value >> 48) & 0xff);
        self.memory[address - memory_base_addr_offset + 7] = @intCast((value >> 56) & 0xff);
    }
}
