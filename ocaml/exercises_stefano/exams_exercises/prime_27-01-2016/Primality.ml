module Primality =
    struct
        
        let trialdivision n =

            let rec trial d =
                if d * d > n then true
                else if (n mod d) = 0 then false
                else trial (d + 1)
            in 
            if n > 1 then trial 2
            else false;;

        (* no check if the input is a Marsenne number. *)
        let lucaslehmer n =
            let p = int_of_float (Float.log2 (float_of_int (n + 1))) in
            let rec seq prev step =
                if step = 0 then prev = 0
                else seq (((prev * prev) - 2) mod n) (step - 1)
            in seq 4 (p-2);;

        let rec range ?(step = 1) ?(res = []) starts ends =
            if starts >= ends then res
            else range ~step:(step) ~res:(starts :: res) (starts + step) ends;;

        (* use a reasonable (both in size and values) set of values for a). *)
        let littlefermat n = 

            let rec modexp ?(res = 1) ?(step = 1) x =
                if step = n then res
                else modexp ~res:((res * x) mod n) ~step:(step + 1) x 
            in
            List.length (
                List.filter (
                    fun x -> (modexp x) <> 1 
                ) (range 3 (int_of_float(Float.log2 (float_of_int(n)))))
            ) = 0;;

        let is_prime n = 
            if n <= 10000 then trialdivision n
            else if n <= 524287 then lucaslehmer n
            else littlefermat n;;
    end;;