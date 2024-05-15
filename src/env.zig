const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
});

const ll = @cImport({
    @cInclude("/home/martin/Travail/zig_test/sdl-zig-demo/Lablib/include/settings.h");
});

const std = @import("std");
const print = std.debug.print;

fn hello_world(_: *ll.Button) void {
    print("Hello, World!\n", .{});
}

pub const Env = struct {
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    lablib: *ll.Lablib,

    pub fn init(alloc: *const std.mem.Allocator) !*Env {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
            c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        }
        const env = try alloc.create(Env);
        env.window = c.SDL_CreateWindow("My Game Window", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, 400, 140, c.SDL_WINDOW_RESIZABLE) orelse
            {
            c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        env.renderer = c.SDL_CreateRenderer(env.win(), -1, 0) orelse {
            c.SDL_Log("Unable to create renderer: %s", c.SDL_GetError());
            return error.SDLInitializationFailed;
        };
        env.init_lablib();
        return env;
    }

    fn init_lablib(self: *Env) void {
        self.lablib = ll.lablib_init(self, @ptrCast(self.win()), @ptrCast(self.ren()), 1);
        const scene = ll.create_scene(self.lablib, 1);
        ll.set_scene_background(self.lablib, scene, "res/bg.png");
        _ = ll.scene_add_button(scene, 0.35, 0.4, 0.3, 0.2, "Hello", @ptrCast(&hello_world));
    }

    pub fn ren(self: *Env) *c.SDL_Renderer {
        return self.renderer;
    }

    pub fn win(self: *Env) *c.SDL_Window {
        return self.window;
    }

    pub fn destroy(self: *Env) void {
        c.SDL_DestroyWindow(self.win());
        c.SDL_DestroyRenderer(self.ren());
        c.SDL_Quit();
        ll.lablib_destroy(self.lablib);
    }
};
