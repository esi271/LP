module Ring (T : R_algebraic_sort.R_algebraic_sort) =
    struct

        let elements = T.elements
        let addition = T.addition
        let multiplication = T.addition

        let is_monoid_under_multiplication () =
            let module M = Monoid.Monoid(
                struct
                    type t = T.t
                    type set = T.set

                    let elements = T.elements
                    let identity = T.identity
                    let add = T.addition
                    let contains = T.contains

                end
            ) in
            M.is_monoid()

        let is_commutative () =
            List.for_all(
                fun e1 -> List.for_all(
                    fun e2 -> addition e1 e2 = addition e2 e1
                ) elements
            ) elements

        let is_distributive () =
            List.for_all (
                fun a-> List.for_all(
                    fun b -> List.for_all (
                        fun c -> multiplication a (addition b c) = addition (multiplication a b) (multiplication a c)
                    ) elements
                ) elements
            ) elements
        
        let is_ring () =
            is_monoid_under_multiplication () && is_commutative () && is_distributive ()
        
    end;;