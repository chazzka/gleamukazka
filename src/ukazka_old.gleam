import gleam/float
import gleam/io
import gleam/list

pub type Object {
  Rectangle(x: Float, y: Float)
  Circle(r: Float)
}

// fn calculate_area(object: Object) {
//   case object {
//     Rectangle(x,y) -> x *. y  //pozor *. je pro floaty, * je pro inty - silne typovany
//     Circle(r) -> 3.14 *. float.power(r, 2.0) // pozor, power samozrejme vraci result
//   }
// }

pub fn divide(numerator: Float, denominator: Float) -> Result(Float, String) {
  case denominator == 0.0 {
    True -> Error("Division by zero is not allowed")
    False -> Ok(numerator /. denominator)
  }
}

// nejprve si ukazeme jak funguji Optional type safe resulty
pub fn safe_division(numerator: Float, denominator: Float) -> String {
  case divide(numerator, denominator) {
    Ok(result) -> "The result is" <> float.to_string(result)
    Error(reason) -> "Error" <> reason
  }
}

// ted chapeme, ze funkce se nemusi podarit
// fn calculate_area(object: Object) {
//   case object {
//     Rectangle(x,y) -> x *. y  //pozor *. je pro floaty, * je pro inty - silne typovany
//     Circle(r) -> 3.14 *. float.power(r, 2.0) // pozor, power samozrejme vraci result
//   }
// }

// fn calculate_area(object: Object) {
//   case object {
//     Rectangle(x,y) -> x *. y  //pozor *. je pro floaty, * je pro inty - silne typovany
//     Circle(r) ->
//TODO: POZOR, nemuzeme vratit dva rozdilne typy
//       case float.power(r, 2.0) {
//         Ok(power) -> 3.14 *. power
//         Error(reason) -> "Cannot calculate area"
//       }
//   }
// }

fn calculate_area(object: Object) {
  case object {
    Rectangle(x, y) -> Ok(x *. y)
    //pozor *. je pro floaty, * je pro inty - silne typovany
    Circle(r) ->
      case float.power(r, 2.0) {
        Ok(power) -> Ok(3.14 *. power)
        Error(_) -> Error("Cannot calculate area")
      }
  }
}

// pub fn main() {
//   let p = Rectangle(4.0, 5.0)
//   io.debug(p)
//   let c = Circle(2.0)
//   io.debug(c)

//   case calculate_area(c) {
//     Ok(result) -> io.debug(float.to_string(result))
//     Error(message) -> io.debug(message)
//   }

//   // a nakonec list of objects
//   let objects = [
//     Rectangle(4.0, 5.0),
//     Circle(2.0),
//     Rectangle(3.0, 7.0),
//     Circle(0.0),
//     Rectangle(3.0, 7.0),
//   ]

//   let areas =
//     objects
//     |> list.map(fn(object: Object) {
//       case calculate_area(object) {
//         Ok(result) -> result
//         Error(_) -> -1.0
//       }
//     })

//   io.debug(areas)
// }
