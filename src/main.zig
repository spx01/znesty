const std = @import("std");
const util = @import("util.zig");
const Nes = @import("Nes.zig");
const instr = @import("instruction.zig");

pub fn main() !void {
    const rom_file = try std.fs.cwd().openFile("other/helloworld.nes", .{});
    defer rom_file.close();

    const test_data = [_]struct { instr.Op, instr.Operand }{
        .{ .jmp, .{ .abs = 0x0004 } },
        .{ .brk, .implicit },
        .{ .jmp, .{ .abs = 0x0000 } },
    };
    const assembled = instr.encodeStreamDebug(&test_data);
    std.debug.dumpHex(assembled);

    //var machine = try Nes.fromRom(rom_file.reader().any());
    var machine = try Nes.fromCpuInstructions(assembled);
    defer machine.deinit();

    machine.debugStuff();
}
