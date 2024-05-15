const Env = @import("env.zig").Env;

const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
});

const ll = @cImport({
    @cInclude("/home/martin/Travail/zig_test/sdl-zig-demo/Lablib/include/settings.h");
});

const std = @import("std");
const print = std.debug.print;

const assert = @import("std").debug.assert;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();

    const env: *Env = try Env.init(&alloc);
    defer env.destroy();

    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (ll.Lablib_PollEvent(env.lablib, @ptrCast(&event)) != 0) {
            switch (event.type) {
                c.SDL_QUIT => quit = true,
                else => {},
            }
        }
        ll.lablib_render(env.lablib);
        c.SDL_RenderPresent(env.ren());
        _ = c.SDL_SetRenderDrawColor(env.ren(), 0, 0, 0, 255);
        _ = c.SDL_RenderClear(env.ren());
        c.SDL_Delay(17);
    }
}
