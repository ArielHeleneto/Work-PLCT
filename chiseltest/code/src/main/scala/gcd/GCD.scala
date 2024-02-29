// See README.md for license details.

package gcd

import chisel3._

class ModuleSample extends Module {
    val io = IO(new Bundle {
        val a = Input(UInt(8.W))
        val b = Input(UInt(8.W))
        val out = Output(UInt(8.W))
    })
    
    io.out := io.a & io.b
}

object MyModule extends App {
    emitVerilog(new ModuleSample(), Array("--target-dir", "generated"))
}
