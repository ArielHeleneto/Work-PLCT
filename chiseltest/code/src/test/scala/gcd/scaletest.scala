import org.scalatest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class ExampleTest extends AnyFlatSpec with Matchers {
    "Integers" should "add" in {
        val i = 2
        val j = 3
        i + j should be (5)
    }

    "Integers" should "multiply" in {
        val i = 3
        val j = 4
        i * j should be (12)
    }
}
