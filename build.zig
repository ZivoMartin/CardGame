const Builder = @import("std").Build;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "sdl-zig-demo",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const lablib_paths: [5][]const u8 = .{ "Lablib/lib/scene.c", "Lablib/lib/cursor.c", "Lablib/lib/button.c", "Lablib/lib/input.c", "Lablib/lib/lablib.c" };

    for (lablib_paths) |path| {
        exe.addCSourceFile(.{
            .file = .{
                .path = path,
            },
        });
    }

    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2_image");
    exe.linkSystemLibrary("SDL2_ttf");
    exe.linkLibC();
    b.installArtifact(exe);

    const run = b.step("run", "Run the demo");
    const run_cmd = b.addRunArtifact(exe);
    run.dependOn(&run_cmd.step);
}
