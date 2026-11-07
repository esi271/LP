module type Ring = sig

    type t

    val (+) : t -> t -> t
    val ( * ) : t -> t -> t
    val (=) : t -> t -> bool

    val inv : t -> t
    val zero : t
    val one : t

end

module IntRing : Ring with type t = int = struct

    type t = int

    let (+) = (+)
    let ( * ) = ( * )
    let (=) = (=)

    let inv a = -a
    let zero = 0
    let one = 1

end

module Zn (N : sig val n : int end) : Ring with type t = int = struct
    
    type t = int

    let n = N.n

    let (mod) a b =
        if a < 0 then ((a+n) mod n)
        else a mod b

    let (+) a b = (a+b) mod n
    let ( * ) a b = (a*b) mod n
    let (=) = (=) 

    let zero = 0
    let one = 1

    let inv a = -a mod n

end
