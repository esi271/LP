module type RingSupport = sig

    type t

    val (+) : t -> t -> t
    val ( * ) : t -> t -> t
    val eq : t -> t -> bool
    val add_id : t
    val mult_id : t
    val inv : t -> t option

end

module ZeroRS : RingSupport with type t = int = struct

    type t = int

    let (+) a b = 0+0
    let ( * ) a b = 0*0
    let eq a b = a = b
    let add_id = 0
    let mult_id = 0
    let inv a = Some 0

end

module ZSet : RingSupport with type t = int = struct

    type t = int
    let (+) = (+)
    let ( * ) = ( * )
    let eq a b = a = b
    let add_id = 0
    let mult_id = 1
    let inv a = Some (-a)
    
end
