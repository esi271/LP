module Taylor =
    struct

        let pow b exp =
            let rec pow_aux ?(res = 1.) exp =
                if exp = 0 then res
                else pow_aux ~res:(res *. b) (exp - 1)
            in pow_aux exp


        let fact n =
            let rec fact_aux ?(acc=1) n =
                if n = 0 then acc
                else fact_aux ~acc:(acc * n) (n-1)
            in fact_aux n;;


        let sin x n =
        let rec sin_aux n acc =
            if n = 0 then acc
            else
                let item = ((pow (float_of_int (-1)) n) /. (float_of_int (fact (2*n + 1)))) *. pow x (2*n + 1) in
                sin_aux (n-1) (acc +. item)
        in sin_aux n x;;

        let cos x n = 
            let rec cos_aux n acc =
                if n = 0 then acc
                else 
                    let item = ((pow (float_of_int (-1)) n) /. (float_of_int (fact (2*n)))) *. pow x (2*n) in
                    cos_aux (n-1) (acc +. item)
            in cos_aux n x;;
    
    end;;