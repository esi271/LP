module type MG_algebraic_sort =
    sig

        type t 
        type set = t list

        val elements : set
        val identity : t
        val add : t -> t -> t
        val contains : t -> bool

    end;;