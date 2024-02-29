// See README.md for license details.

package gcd

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class GCDSpec extends AnyFreeSpec with Matchers {

  "Gcd should calculate proper greatest common denominator" in {
    simulate(new ModuleSample) { dut =>
      var a,b: Int = 0
      while (a<=100&&b<=100){
        dut.io.a.poke(a)
        dut.io.b.poke(b)
        dut.clock.step()
        println("Result: " +a.toString+" & "+b.toString+" = "+dut.io.out.peek().toString+" should be "+ (a&b).toString)
        assert((a&b)==dut.io.out.peek().litValue(),"Caculation failed")
        a+=1
        b+=2
      }
    }
  }
}