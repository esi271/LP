module Goldbach  =
    struct

        type partition = (int * (int * int))
        exception Invalid_input of int

        let is_prime n =
            let rec check d =
                if d * d > n then true
                else if (n mod d) = 0 then false
                else check (d + 1)
            in 
            if n < 2 then false
            else check 2

        let goldbach n =
            if (n <= 2) || (n mod 2 <> 0) then raise (Invalid_input n)
            else
                let f = List.find (
                    fun e ->
                        is_prime e && is_prime (n -e)
                ) (List.init (n-(n/2 + 1)) (fun e -> e + 2))
                in
                (n, (f, (n-f)))

        (*n incluso, m escluso*)
        let goldbach_list (n, m) =
            List.fold_right (
                fun e acc ->
                    if e mod 2 = 0 then (goldbach e) :: acc
                    else acc
            ) (List.init (m-n) (fun e -> e + n)) []
    
    end;;