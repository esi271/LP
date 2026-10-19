module type R_algebraic_sort =
    sig

        type t
        type set = t list

        val elements : set
        val addition : t -> t -> t
        val multiplication : t -> t -> t
        val identity : t
        val contains : t -> bool

    end;;