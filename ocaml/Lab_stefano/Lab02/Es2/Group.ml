module Group (T : MG_algebraic_sort.MG_algebraic_sort) =
    struct

        let elements = T.elements
        let identity = T.identity
        let op = T.add

        module M = Monoid.Monoid(T)

        let is_associative () =
            M.is_associative()

        let is_identity () =
            M.is_identity()

        let is_closed () =
            List.for_all (
                fun e1 -> List.for_all (
                    fun e2 -> T.contains (op e1 e2)
                ) elements
            ) elements

        let invertibility () = 
            List.for_all(
                fun e1 -> List.exists(
                    fun e2 -> ((op e1 e2) = identity) && ((op e2 e1) = identity)
                ) elements
            ) elements
        
        let is_group () =
            is_associative () && is_identity () && is_closed () && invertibility()

    end;;

