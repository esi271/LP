module IntMatrix = Matrix(
    struct

        type t = int

        let zero = 0
        let identity = 1
        let add = (+)
        let mul = ( * )
        let to_string e = string_of_int e

    end
)