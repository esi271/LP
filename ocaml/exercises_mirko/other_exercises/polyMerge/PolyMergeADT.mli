module type PolyMergeADT = sig 

    type elt
    type t

    val empty : unit -> t
    val length : t -> int
    val append : t -> t -> t
    val cons : elt -> t -> t
    val is_empty : t -> bool
    val rev : t -> t

    val hd : t -> elt
    val tl : t -> t

end
