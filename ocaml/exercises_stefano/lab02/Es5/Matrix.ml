module Matrix (T : MatrixElementADT) : (MatrixADT with type elm = T.t) =
    struct

        type matrix = T.t list list
        type elm = T.t
        exception IncompatibleDimension

        let create n e =
            List.init n (
                fun _ -> List.init n (fun _ -> e)
            ) 

        let n_rows a = List.length a

        let n_colums a = List.length (List.nth a 0)

        let get_element m row col = List.nth (List.nth m row) col

        let get_colum m c =
            List.init (List.length m) (fun r -> get_element m r c)

        let get_colums m =
            List.init (n_colums m) (fun c -> get_colum m c)

        let create_matrix m = m
        
        let identity_matrix n =
            create n T.identity

        let zeroes_matrix n = 
            create n T.zero

        let matrix_equivalence a b = a = b

        let matrix_copy a = a

        let matrix_addition a b =
            if (n_colums a = n_colums b) && (n_rows a = n_rows b) then
                List.map2 (
                    fun row_a row_b -> List.map2 (
                        fun el_a el_b -> T.add el_a el_b
                    ) row_a row_b
                ) a b
            else raise IncompatibleDimension

        let scalar_matrix_multiplication s m =
            List.map (
                fun row -> List.map (
                    fun e -> T.mul s e
                ) row
            ) m

        let matrix_matrix_multiplication a b =
            if (n_colums a) = (n_rows b) then
                let columns = get_colums b in
                List.map (
                    fun row -> 
                        List.fold_right ( 
                            fun e acc ->
                                (List.fold_left2 (
                                    fun acc e1 e2 -> T.add (T.mul e1 e2) acc
                                ) T.zero e row) :: acc
                        ) columns []
                ) a
            else raise IncompatibleDimension
        

        let matrix_transposition m =
            get_colums m

        let matrix_norm = function
        | hd :: tl ->
            List.fold_left (
                fun acc e ->
                    let res = List.fold_left (fun acc' e' -> T.add e' acc') T.zero e in
                    if res > acc then res
                    else res
            ) (List.fold_left (fun acc e -> T.add e acc) T.zero hd) tl
        | [] -> T.zero


        let print m =
            List.iter (
                fun row -> List.iter (
                    fun e -> Printf.printf " %s " (T.to_string e)
                ) row;
                Printf.printf "\n"
            ) m
    end;;