const std = @import("std");

pub fn build(builder: *std.Build) void {
    const target = builder.standardTargetOptions(.{});
    const optimize = builder.standardOptimizeOption(.{});

    const exe = builder.addExecutable(.{
        .name = "zigemu-riscv",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    builder.installArtifact(exe);

    const unit_tests = builder.addTest(.{
        .root_source_file = .{ .path = "src/tests.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = builder.addRunArtifact(unit_tests);
    const test_step = builder.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
