const std = @import("std");
const CPU = @import("CPU.zig");
const Bus = @import("Bus.zig");

pub fn main() !void {
    var cpu: CPU = undefined;
    cpu.reset();

    cpu.bus.store(u8, cpu.program_counter, 0x45);
    std.debug.print("{d}\n", .{cpu.peek(u8)});
}
