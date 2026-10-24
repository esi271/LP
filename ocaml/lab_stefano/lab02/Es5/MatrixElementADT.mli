module type MatrixElementADT =
    sig

        type t

        val zero : t
        val identity : t
        val add : t -> t -> t
        val mul : t -> t -> t
        val to_string : t -> string
      
    end