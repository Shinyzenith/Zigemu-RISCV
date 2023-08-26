const std = @import("std");
const CPU = @import("CPU.zig");
const Bus = @import("Bus.zig");

pub fn main() !void {
    var cpu: CPU = undefined;
    cpu.reset();
    std.debug.print("{d}\n", .{cpu.fetch()});
}
