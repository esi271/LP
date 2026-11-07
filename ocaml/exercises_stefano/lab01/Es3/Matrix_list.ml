module MatrixList = 
    struct
        type matrix = int list list

        (* n = righe, m = colonne*)
        let zeroes n m = 
            let rec build_list n acc=
                if n = 0 then acc
                else build_list (n-1) (0 :: acc)
            in let rec build_matrix n acc =
                if n = 0 then acc
                else build_matrix (n-1) ((build_list m []) :: acc)
            in build_matrix n [];;
        
        let identity size =
            let rec build_list size d acc =
                if size = 0 then acc
                else if d = size then build_list (size - 1) d (1 :: acc)
                else build_list (size - 1) d (0 :: acc)
            in let rec build_matrix n acc =
                if n = 0 then acc
                else build_matrix (n-1) ((build_list size n []) :: acc)
            in build_matrix size [];;

        let init size =
            let rec build_list size n acc =
                if size = 0 then acc
                else build_list (size - 1) (n-1) (n :: acc)
            in let rec build_matrix n acc =
                if n = 0 then acc
                else build_matrix (n-1) ((build_list size (n * size) []) :: acc)
            in build_matrix size [];;
        
        let transpose matrix =
            let rec extract_1_column matrix acc matrix_result=
                match matrix with
                | [] -> (List.rev acc, List.rev matrix_result)
                | (hd :: []) :: mat -> extract_1_column mat (hd :: acc) matrix_result
                | (hd :: tl) :: mat -> extract_1_column mat (hd :: acc) (tl :: matrix_result)
            in let rec built_t_matrix matrix acc =
                if matrix = [] then List.rev acc
                else 
                    let (col, rest) = extract_1_column matrix [] [] in
                    built_t_matrix rest (col :: acc)
            in built_t_matrix matrix [];;

    end;;