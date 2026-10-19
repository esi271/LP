module Monoid (T : MG_algebraic_sort.MG_algebraic_sort) =
    struct

        let elements = T.elements
        let identity = T.identity
        let op = T.add

        let is_associative () =

            let check e1 e2 e3 =
                op (op e1 e2) e3 = op e1 (op e2 e3)
            in    
            List.for_all(
                fun e1 -> List.for_all(
                    fun e2 -> List.for_all (
                        fun e3 -> check e1 e2 e3
                    ) elements
                ) elements
            ) elements

        let is_identity () =
            List.for_all (fun e -> (op e identity) = e) elements
        
        let is_monoid () =
            is_identity () && is_associative ()
      
    end;;