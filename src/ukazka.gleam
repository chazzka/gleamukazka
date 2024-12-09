import gleam/float
import gleam/io
import gleam/list

pub type Object {
  Rectangle(x: Float, y: Float)
  Circle(r: Float)
}

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

fn calculate_perimeter(object: Object) -> Result(Float, String) {
  case object {
    Rectangle(x, y) -> Ok(2.0 *. { x +. y })
    Circle(r) ->
      case r <. 0.0 {
        True ->
          Error("Cannot calculate perimeter for a circle with negative radius")
        False -> Ok(2.0 *. 3.14 *. r)
      }
  }
}

pub fn map_objects(
  objects: List(Object),
  calculation_fn: fn(Object) -> Result(Float, String),
) -> List(Float) {
  objects
  |> list.map(fn(object: Object) {
    case calculation_fn(object) {
      Ok(result) -> result
      // Append the calculated value
      Error(_) -> -1.0
      // Append -1.0 for failures
    }
  })
}

// TODO: comment out main in ukazka.gleam
// TODO: DELETE BUILD
pub fn main() {
  let p = Rectangle(4.0, 5.0)
  io.debug(p)
  let c = Circle(2.0)
  io.debug(c)

  case calculate_area(c) {
    Ok(result) -> io.debug(float.to_string(result))
    Error(message) -> io.debug(message)
  }

  // a nakonec list of objects
  let objects = [
    Rectangle(4.0, 5.0),
    Circle(2.0),
    Rectangle(3.0, 7.0),
    Circle(0.0),
    Rectangle(10.0, 7.0),
  ]

  let areas = map_objects(objects, calculate_area)
  io.debug(areas)
  let perimeters = map_objects(objects, calculate_perimeter)
  io.debug(perimeters)
}
