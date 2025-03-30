const std = @import("std");
const sdl = @import("zsdl2");

test {
    _ = std.testing.refAllDeclsRecursive(@This());
}

/// Initialization flags
pub const InitFlags = packed struct(u32) {
    jpg: bool = false,
    png: bool = false,
    tif: bool = false,
    webp: bool = false,
    jxl: bool = false,
    avif: bool = false,
    padding: u26 = 0,

    pub const everything: InitFlags = .{
        .jpg = true,
        .png = true,
        .tif = true,
        .webp = true,
        .jxl = true,
        .avif = true,
    };
};

/// Initialize SDL_image.
pub fn init(flags: InitFlags) !InitFlags {
    const result = IMG_Init(flags);
    return if (result == 0) sdl.makeError() else @as(InitFlags, @bitCast(result));
}
extern fn IMG_Init(flags: InitFlags) c_int;

/// Deinitialize SDL_image.
pub fn quit() void {
    IMG_Quit();
}
extern fn IMG_Quit() void;

/// Load an image from a filesystem path into a software surface.
pub fn load(file: [:0]const u8) !*sdl.Surface {
    return IMG_Load(file) orelse sdl.makeError();
}
extern fn IMG_Load(file: [*:0]const u8) ?*sdl.Surface;

/// Load an image from an SDL data source into a software surface.
pub fn loadRW(context: *anyopaque, freesrc: c_int) !*sdl.Surface {
    return IMG_Load_RW(context, freesrc) orelse sdl.makeError();
}
extern fn IMG_Load_RW(context: *anyopaque, freesrc: c_int) ?*sdl.Surface;

/// Load an XPM image from a memory array.
pub fn readXpmFromArray(xpm: *[*:0]const u8) !*sdl.Surface {
    return IMG_ReadXPMFromArray(xpm) orelse sdl.makeError();
}
extern fn IMG_ReadXPMFromArray(xpm: *[*:0]const u8) ?*sdl.Surface;
